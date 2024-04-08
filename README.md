# HofBox OpenHorizon Development Machine

Dieses Repository stellt ein [Vagrant](https://developer.hashicorp.com/vagrant)-basiertes Setup bereit um schnell OpenHorizon Services zu entwickeln oder zu testen.

**Inhalt:**

- [HofBox OpenHorizon Development Machine](#hofbox-openhorizon-development-machine)
- [Schnellstart mit einem Test-Service](#schnellstart-mit-einem-test-service)
- [Allgemeines zur HofBox](#allgemeines-zur-hofbox)
- [Beispiel-Services](#beispiel-services)
- [Beispiel-Kommandos für den Umgang mit Open Horizon](#beispiel-kommandos-für-den-umgang-mit-open-horizon)
  * [Open Horizon Exchange Commands](#open-horizon-exchange-commands)
  * [Open Horizon Exchange System Org Commands](#open-horizon-exchange-system-org-commands)
  * [Open Horizon Hub Admin Commands](#open-horizon-hub-admin-commands)
  * [Management vom Exchange](#management-vom-exchange)
  * [Entwicklung neuer Services](#entwicklung-neuer-services)
  * [Umgang mit Properties](#umgang-mit-properties)

# Schnellstart mit einem Test-Service

VM erstellen inkl. Ausführen des Bootstrap-Skriptes:
```
vagrant up
```

In die laufende VM mittels SSH einloggen:
```
vagrant ssh 
```

Beispiel-Service "ollama" am internen Horizon Exchange registrieren:
```
cd ~/horizon-service-examples/hofbox-ollama
hzn exchange service publish -f horizon/service.definition.json -P -u "RSFLAB/rsflabadmin:testpassword"
```

Beispiel-Service "open-webui" (mit Abhängigkeit zu "ollama") testweise starten:
```
cd ~/horizon-service-examples/hofbox-ollama-open-webui
docker pull fkuntke/ollama-open-webui:0.1.114
sudo hzn dev service start -S --user-pw=RSFLAB/rsflabadmin:testpassword
```

Nun sollten die beiden Container (hofbox-ollama & hofbox-ollama-open-webui) laufen:
```
docker ps
```

Die Weboberfläche von hofbox-ollama-open-webui lässt sich nun mittels IP-Adresse (siehe `ip a`) und Port 9091 von dem Host-System aufrufen. Der erste Nutzer, der sich registriert ist automatisch der Admin-Account.


# Allgemeines zur HofBox

Die HofBox ist ein dezentraler Rechner, der hauptsächlich Aufgaben der Datenhaltung und -verarbeitung für die landwirtschaftliche Praxis erfüllt. Weitere Informationen dazu hier: [https://farmwiki.de/de/Tutorials/EdgeComputing/HofBox](https://farmwiki.de/de/Tutorials/EdgeComputing/HofBox)

Im aktuellen HofBox-Konzept werden Server-Anwendungen in Form von Containern (Docker) ausgeführt.
Die Bereitstellung der Services und Verteilung der Services auf die entsprechenden HofBoxen (Provisionierung) wird über Open Horizon gewährleistet.
Entsprechend müssen die containierisierten Anwendungen als Horizon-Service vorliegen.
Ein Problem beim Entwickeln neuer Services ist dabei das Testen, da das Bootstrapping von Entwicklungsumgebungen für OpenHorizon bisher noch nicht vollständig vereinfacht wurde.
Dieses Repository unterstützt hier durch eine vordefinierte Entwicklungsumgebung inklusive Beispiel-Services.
Dabei wird über Vagrant eine definierte VM erzeugt (je nach Host-System mit unterschiedlichen Backends, z.B. VirtualBox, VMWare, Hyper-V, …), die das Projekt "[All-in-One Horizon Management Hub, Agent and CLI](https://open-horizon.github.io/docs/mgmt-hub/docs/)" von Open Horizon installiert.


# Beispiel-Services

Im Ordner `~/horizon-service-examples/` liegen Beispiel-Services:
* `hofbox-ollama`, basierend auf https://github.com/ollama/ollama in Version 0.1.29
* `hofbox-ollama-open-webui`, basierend auf https://github.com/open-webui/open-webui in Version 0.1.114


# Beispiel-Kommandos für den Umgang mit Open Horizon

Das Tool `hzn` dient der Arbeit mit Open Horizon - sowohl clientseitig, als auch serverseitig.
`hzn` erlaubt die Registrierung eines Nodes (HofBox) an einem Management Hub, das Setzen neuer Properties, Testen neuer Services, etc. …


## Open Horizon Exchange Commands

Passende Umgebungsvariablen setzen:
```
export HZN_ORG_ID=myorg
export HZN_EXCHANGE_USER_AUTH=admin:EUFebrxcrXjlQwynlQvnlSRwTNj7HV
```

Alle verfügbaren hzn exchange Sub-Befehle anzeigen:
```
hzn exchange --help
```

Die mitgelieferten IBM-Beispiel Services auflisten: 
```
hzn exchange service list IBM/
```

Die mitgelieferten IBM-Beispiel Muster (pattern) auflisten: 
```
hzn exchange pattern list IBM/
```

Die mitgelieferten IBM-Beispiel Richtlinien (deployment policies) auflisten:
```
hzn exchange deployment listpolicy
```

Die Richtlinie, die zum Deployment des HelloWorld Service geführt hat anzeigen:
```
hzn deploycheck all -b policy-ibm.helloworld_1.0.0
```

Nodes vom Exchange anzeigen (sollte nur die eine sein):
```
hzn exchange node list
```

Nutzer der eigenen Organistation (org) auflisten:
```
hzn exchange user list
```

Mittels "verbose flag" (`-v`) lassen sich die aufgerufenen Exchange REST API Aufrufe anzeigen, z.B.:
```
hzn exchange user list -v
```

Öffentliche Dateien im CSS anzeigen lassen, die der agent-install.sh nutzen kann, zum Installieren/Registrieren des Agenten auf Edge Nodes:
```
hzn mms -o IBM -u "$HZN_ORG_ID/$HZN_EXCHANGE_USER_AUTH" object list -d -t agent_files
```


## Open Horizon Exchange System Org Commands

Umgebungsvariablen mit den Zugangsdaten setzen:
```
export HZN_ORG_ID=IBM
export HZN_EXCHANGE_USER_AUTH=admin:vwt9wkwekC6DF6k4EC9SXNa6iOJguY
```

Auflisten der registrierten Nutzer. Beachte, dass man als normaler Nutzer nur das Recht hat sich selbst zu sehen. :
```
hzn exchange user list
```

Auflisten der Agbot Resourcen:
```
hzn exchange agbot list
```

Auflisten der DeploymentPolicies des Agbot: 
```
hzn exchange agbot listdeploymentpol agbot 
```

Auflisten der Pattern des Agbot: 
```
hzn exchange agbot listpattern agbot
```


## Open Horizon Hub Admin Commands

Siehe auch:
* [Open Horizon Exchange Server and REST API (Open Horizon Docs)](https://open-horizon.github.io/docs/exchange-api/README/)
* [OpenAPI/Swagger Exchange API (Open Horizon Docs)](https://open-horizon.github.io/docs/api/exchange_swagger/)

Passende Umgebungsvariablen setzen:
```
export HZN_ORG_ID=root
export HZN_EXCHANGE_USER_AUTH=hubadmin:CgYAt5aiJo5UI3wA8eaSLRdkIdmNpx
```

Auflisten der registrierten Organisationen:
```
hzn exchange org list
```

Neue Organistation RSFLAB hinzufügen:
```
hzn exchange org create -d 'Resilient Smart Farming Laboratory' -a IBM/agbot RSFLAB
```

Den Agbot so konfigurieren, dass er die (Beispiel-)Services von dieser Organsitation nutzen kann:
```
hzn exchange agbot addpattern IBM/agbot IBM '*' RSFLAB
```

Neuen Nutzer in der neuen Organisation anlegen (leider gibt es hierfür kein `hzn` Kommando(?), nur per API möglich):
```
curl -X 'POST' \
  -u "root/root:fPCDjEPy7ccMeKeJ2Fv7bisESvfzt8" \
  'http://localhost:3090/v1/orgs/RSFLAB/users/rsflabadmin' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "password": "testpassword",
  "admin": true,
  "email": "mail@example.com"n
}'
```


## Management vom Exchange

Siehe hierzu: https://open-horizon.github.io/docs/mgmt-hub/docs/#what-to-do-next


## Entwicklung neuer Services

Mehr Informationen auf den offiziellen Tutorial-Seiten: [Transform image to edge service (Open Horizon Docs)](https://open-horizon.github.io/docs/developing/transform_image/)

Umgebungsvariablen mit den Zugangsdaten setzen:
```
export HZN_ORG_ID=RSFLAB
export HZN_EXCHANGE_USER_AUTH=rsflabadmin:testpassword
```

Ein neues eigenes Verzeichnis für den neuen Service erzeugen:
```
mkdir myservice
cd myservice
```

Template-Dateien für einen neuen Service "myservice" erzeugen. Alle Eigenschaften vom Service lassen sich noch bearbeiten:
```
hzn dev service new -s myservice -V 1.0.0 -i $DOCKER_HUB_ID/myservice --noImageGen
```


Die folgenden Befehle gehen davon aus, dass man im Ordner ist, in dem sich "horizon" befindet. Ist der Ordner `horizon` vorhanden?:
```
ls
```

Syntax überprüfen:
```
hzn dev service verify
```

Service starten:
```
hzn dev service start -S
```

Es kann nun getestet werden, ob die Docker-Container wie gewünscht funktionieren. Wenn alles wie gewünscht funktioniert weitermachen.

Service stoppen:
```
hzn dev service stop
```

Zum Hochladen ist ein Docker Login notwendig (Anmerkung: Es gibt keine Möglichkeit externe Images zu nutzen?)
```
docker login
```

Service hochladen:
```
hzn exchange service publish -f horizon/service.definition.json
```

Alle registrierten Services der eigenen Organisationseinheit auflisten:
```
hzn exchange service list
```

Pattern hochladen:
```
hzn exchange pattern publish -f horizon/pattern.json
```

Alle registrierten Pattern der eigenen Organisationseinheit auflisten:
```
hzn exchange pattern list
```


## Umgang mit Properties

Umgebungsvariablen mit den Zugangsdaten setzen:
```
export HZN_ORG_ID=RSFLAB
export HZN_EXCHANGE_USER_AUTH=rsflabadmin:testpassword
```

Eine neue Property dem aktuellen Node hinzufügen:
```
hzn pol list | jq '.deployment.properties +=  [{"name": "chirpstack-2024.2.1", "value": "true", "type": "string"}]' | hzn pol update -v -f-
```


Weitere Informationen: [Service definition (Open Horizon Docs)](https://open-horizon.github.io/docs/anax/docs/service_def/)
