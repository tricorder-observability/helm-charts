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

