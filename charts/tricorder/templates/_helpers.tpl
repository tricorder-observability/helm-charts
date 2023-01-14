{{/* Expand the name of the chart. */}}
{{- define "tricorder.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "tricorder.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/* Create chart name and version as used by the chart label. */}}
{{- define "tricorder.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Common labels */}}
{{- define "tricorder.labels" -}}
helm.sh/chart: {{ include "tricorder.chart" . }}
{{ include "tricorder.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/* Selector labels */}}
{{- define "tricorder.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tricorder.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/* Allow the release namespace to be overridden */}}
{{- define "tricorder.namespace" -}}
  {{- if .Values.namespaceOverride -}}
    {{- .Values.namespaceOverride -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}
{{- end -}}

{{/* Extract the password from db uri */}}
{{- define "tricorder.dburi.password" -}}
  {{- $values := urlParse .Values.promscale.connection.uri }}
  {{- $userInfo := get $values "userinfo" }}
  {{- $userDetails :=  split ":" $userInfo }}
  {{- $pwd := $userDetails._1 }}
  {{- printf $pwd -}}
{{- end -}}

{{/* Set Grafana Datasource Connection Password */}}
{{- define "tricorder.grafana.datasource.connection.password" -}}
{{- $kubePrometheus := index .Values "kube-prometheus-stack" -}}
{{- $isDBURI := ne .Values.promscale.connection.uri "" -}}
{{- $grafanaDatasourcePasswd := ternary (include "tricorder.dburi.password" . ) ($kubePrometheus.grafana.timescale.datasource.pass) ($isDBURI) -}}
  {{- if ne $grafanaDatasourcePasswd "" -}}
    {{- printf $grafanaDatasourcePasswd -}}
  {{- else -}}
    {{- printf "${GRAFANA_PASSWORD}" -}}
  {{- end -}}
{{- end -}}

{{/* Extract the username from db uri */}}
{{- define "tricorder.dburi.user" -}}
  {{- $values := urlParse .Values.promscale.connection.uri }}
  {{- $userInfo := get $values "userinfo" }}
  {{- $userDetails :=  split ":" $userInfo }}
  {{- $user := $userDetails._0 }}
  {{- printf $user -}}
{{- end -}}

{{/* Extract the sslmode from db uri */}}
{{- define "tricorder.dburi.sslmode" -}}
  {{- $values := urlParse .Values.promscale.connection.uri }}
  {{- $queryInfo := get $values "query" }}
  {{- $sslInfo := regexFind "ssl[mM]ode=[^&]+" $queryInfo}}
  {{- $sslDetails := split "=" $sslInfo }}
  {{- $sslMode := $sslDetails._1 }}
  {{- printf $sslMode -}}
{{- end -}}

{{/* Extract the dbname from db uri */}}
{{- define "tricorder.dburi.dbname" -}}
  {{- $values := urlParse .Values.promscale.connection.uri }}
  {{- $dbDetails := get $values "path" }}
  {{- $dbName := trimPrefix "/" $dbDetails }}
  {{- printf $dbName -}}
{{- end -}}

{{/* Create the name of the service account to use */}}
{{- define "tricorder.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "tricorder.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "starship" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Build the list of port for deployment service */}}
{{- define "tricorder.apiServer.svc.ports" -}}
{{- $ports := deepCopy .Values.apiServer.ports }}
{{- range $key, $port := $ports }}
{{- if $port.enabled }}
- name: {{ $key }}
  port: {{ $port.servicePort }}
  targetPort: {{ $port.servicePort }}
  protocol: {{ $port.protocol }}
{{- end }}
{{- end }}
{{- end }}

{{/* Build the list of port for deployment service */}}
{{- define "tricorder.ui.svc.ports" -}}
{{- $ports := deepCopy .Values.ui.ports }}
{{- range $key, $port := $ports }}
{{- if $port.enabled }}
- name: {{ $key }}
  port: {{ $port.servicePort }}
  targetPort: {{ $port.servicePort }}
  protocol: {{ $port.protocol }}
{{- end }}
{{- end }}
{{- end }}

{{/* Build the list of port for deployment service */}}
{{- define "tricorder.svc.ports" -}}
{{ include "tricorder.apiServer.svc.ports" . }}
{{ include "tricorder.ui.svc.ports" . }}
{{- end }}