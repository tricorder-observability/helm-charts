{{/*
Create the name of the ui service account to use
*/}}
{{- define "tricorder.ui.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "tricorder.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "tricorder-ui" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Build the list of port for deployment service */}}
{{- define "tricorder.ui.svc.ports" -}}
{{- $ports := deepCopy .Values.ports }}
{{- range $key, $port := $ports }}
{{- if $port.enabled }}
- name: {{ $key }}
  port: {{ $port.servicePort }}
  targetPort: {{ $port.servicePort }}
  protocol: {{ $port.protocol }}
{{- end }}
{{- end }}
{{- end }}
