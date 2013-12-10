/*
Exemple de code pour envoyer au logiciel Meteo
 */

void setup() {
  // initialisation de la communication série 9600 bauds
  Serial.begin(9600);
}

void loop() {
// envoie de la trame test, remplacer les random par les valeurs capteur
  Serial.print("H"); // caractere de début de trame
  Serial.print("/"); // séparateur de champs
  Serial.print(random(-20,40)); // température
  Serial.print("/");
  Serial.print(random(0,100)); // humidité
  Serial.print("/");
  Serial.print(random(0,1000)); // pression
  Serial.print("/");
  Serial.println(); // envoi du retour chariot (LF)
  delay(1000);        // delay d'une seconde
}
