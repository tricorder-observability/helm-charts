{{/*
Create the name of the service account to use
*/}}
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
