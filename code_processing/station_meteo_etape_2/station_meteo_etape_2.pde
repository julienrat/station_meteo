/*
Petit programme pour receptionner plusieurs infos
 via le port série arduino
 la trame envoyée par arduino est du type :
 H/temperature/humidité/pression/LF
 H est le début d'une trame
 LF est le retour chariot de println
 / est le séparateur de champs
 
 */

import processing.serial.* ;// bibliotheque permettant de gérer les communications série
Serial port_arduino; // création de l'objet connexion série
int index_port=0; // numéro de port
int vitesse = 9600; // vitesse de la communication série en bauds
String trame="";
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
      trame=port_arduino.readStringUntil(LF); //récupere la chaine de caractere jusqu'au retour chariot de println)
  }
  fill(0); // couleur noire
  rect(0, 0, 400, 400); // un rectangle pour le raffraichissement de la fenetre
  fill(0, 255, 0); // couleur verte
  textSize(32); // taille du texte
  text("Valeur reçue :",100,150); // affiche un texte
   textSize(12);
  if (trame!=null) { // vérifie que l'on ne reçois pas n'importe quoi
    text(trame, 20, 200); // affichage du texte dans la fenetre
    String [] valeurs=trame.split("/"); // on découpe grace au séparateur
                                        // puis on alimente le tableau "valeurs"
   if(valeurs[0].equals("H") && valeurs.length==5){ // on vérifie que la valeur 0 est bien le caractere de début (H) et que la taille est de 5 lignes
     for(int i=1;i<valeurs.length-1;i++){ // on pars de 1 (on ne veux plus du caractere du début, et on s'arrete avant la fin car pas besoin du retour chariot 
      println("valeurs : "+ i+" ==>  "+valeurs[i]); // on affiche les valeurs valeurs[1] = température, valeurs[2] = humidité, valeurs[3] à la pression
     } 
    }
   
  }
}

