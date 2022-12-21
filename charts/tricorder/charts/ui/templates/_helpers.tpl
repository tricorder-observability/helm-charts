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
