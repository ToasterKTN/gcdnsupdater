project="googleprojectcode-000"
zone="dnszonename"
recordname="dnsentry.yourdomain.com"
ipurl="https://ip.ktn.ch/"

gcloud config set project ${project}
gcloud dns record-sets list --zone=${zone} --type A --name ${recordname}

oldip=$(gcloud dns record-sets list --zone=${zone} --type A --name ${recordname} | tail -1 | awk -F ' ' '{printf $4}')
newip=$(curl -s ${ipurl})
if [ "X${oldip}" != "X${newip}" ]; then
  gcloud dns record-sets transaction start -z=${zone}
  gcloud dns record-sets transaction remove -z=${zone} --name="${recordname}." --type=A --ttl=300 "${oldip}"
  gcloud dns record-sets transaction add -z=${zone} --name="${recordname}." --type=A --ttl=300 "${newip}"
  gcloud dns record-sets transaction execute -z=${zone}
fi
