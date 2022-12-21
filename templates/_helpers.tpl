{{/*
Expand the name of the chart.
*/}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "tricorder.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "tricorder.labels" -}}
helm.sh/chart: {{ include "tricorder.chart" . }}
{{ include "tricorder.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "tricorder.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tricorder.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the apiServer service account to use
*/}}
{{- define "tricorder.apiServer.serviceAccountName" -}}
{{- if .Values.apiServer.serviceAccount.create }}
{{- default (include "tricorder.fullname" .) .Values.apiServer.serviceAccount.name }}
{{- else }}
{{- default "tricorder-api-server" .Values.apiServer.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the ui service account to use
*/}}
{{- define "tricorder.ui.serviceAccountName" -}}
{{- if .Values.ui.serviceAccount.create }}
{{- default (include "tricorder.fullname" .) .Values.ui.serviceAccount.name }}
{{- else }}
{{- default "tricorder-ui" .Values.ui.serviceAccount.name }}
{{- end }}
{{- end }}
