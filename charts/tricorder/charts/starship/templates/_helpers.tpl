{{/*
Create the name of the apiServer service account to use
*/}}
{{- define "tricorder.apiServer.serviceAccountName" -}}
{{- if .Values.apiServer.serviceAccount.create }}
{{- default (include "tricorder.fullname" .) .Values.apiServer.serviceAccount.name }}
{{- else }}
{{- default "starship-api-server" .Values.apiServer.serviceAccount.name }}
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
