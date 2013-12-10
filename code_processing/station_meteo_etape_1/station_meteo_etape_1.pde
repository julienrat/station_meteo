/*
Petit programme pour receptionner 
 via le port série les données arduino
 */

import processing.serial.* ;// bibliotheque permettant de gérer les communications série
Serial port_arduino; // création de l'objet connexion série
int index_port=0; // numéro de port
int vitesse = 9600; // vitesse de la communication série en bauds
String valeur_recue="";
int LF=10; // valeur du retour chariot en ASCII
void setup() {
  size(400, 400); //taille de la fenetre
  println(Serial.list()); // liste la liste des ports disponibles
  //connexion à arduino //
  port_arduino=new Serial(this, Serial.list()[index_port], vitesse); 
  ///////////////////////
}

void draw() {

  if (port_arduino.available()>0) { // si on reçoit qqchose sur le port série
      valeur_recue=port_arduino.readStringUntil(LF); //récupere la chaine de caractere jusqu'au retour chariot de println)
  }
  fill(0); // couleur noire
  rect(0, 0, 400, 400); // un rectangle pour le raffraichissement de la fenetre
  fill(0, 255, 0); // couleur verte
  textSize(32); // taille du texte
  text("Valeur reçue :",100,150); // affiche un texte
  if (valeur_recue!=null) { // vérifie que l'on ne reçois pas n'importe quoi
    text(valeur_recue, 200, 200); // affichage du texte dans la fenetre
    println(valeur_recue); //on affiche dans la console
  }
}

