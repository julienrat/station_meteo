/* CC by SA les petits débrouillards 2013
 Petit programme pour receptionner plusieurs infos
 via le port série arduino
 la trame envoyée par arduino est du type :
 H/temperature/humidité/pression/LF
 H est le début d'une trame
 LF est le retour chariot de serial.println();
 / est le séparateur de champs
 
 ICI on va utiliser  la  fonction "serialEvent()" qui se lance a chaque fois que l'on reçois qqchose sur le port série
 puis enregister en CSV les valeurs reçues
 */

import processing.serial.* ;// bibliotheque permettant de gérer les communications série USB

Serial port_arduino; // création de l'objet connexion série
int index_port=0; // numéro de port a modifier en fonction de l'ordi et du resultat de " println(Serial.list()); "
int vitesse = 9600; // vitesse de la communication série en bauds
String trame=""; // trame reçue avant saucissonage
String temp=""; // variable globale température
String hum=""; // variable globale humidité
String pression=""; // variable globale de pression 
PrintWriter fichier; // création de l'objet "fichier"
int LF=10; // valeur du retour chariot en ASCII ATTENTION SOUS WINDOWS LA FIN DE LIGNE 13 10 adapter en fonction

PImage fond; // objet image
PFont police_temp, police_hum_pression ; // objet police de texte
void setup() { // fonction setup, executée une seule fois au lancement du programme
  size(300, 400); //taille de la fenetre en pixels
  fond=loadImage("image_fond.png"); //chargement de l'image de fond
  police_temp=loadFont("URWGothicL-Demi-70.vlw"); // chargement de la police
  police_hum_pression =loadFont("URWGothicL-Demi-30.vlw"); // chargement de la police
  textAlign(CENTER,CENTER); // centrage du texte
  println(Serial.list()); // liste la liste des ports disponibles
  //connexion à arduino //
  port_arduino=new Serial(this, Serial.list()[index_port], vitesse); 
  ///////////////////////
  String dateheure=day()+""+month()+""+year()+"_"+hour()+minute()+second();
  fichier = createWriter("enregistrements/enr_"+dateheure+".csv"); // on cree un fichier
  fichier.println("Date;Heure;Température;Humidité;Pression"); // on ecris la première ligne du tableau
}

////////////////////////////////////////////////////////////////////
/* la fonction draw() est similaire à la fonction loop dans arduino, 
 elle tourne en boucle, elle sera interrompue par la fonction serialEvent(),
 puis reprendra sa route
 */
////////////////////////////////////////////////////////////////////

void draw() { 
  fill(0); // couleur noire
  image(fond, 0, 0, 300, 400); // affiche l'image de fond a chaque raffraichissement
  fill(248, 255, 50); // couleur jaune
  textFont(police_temp); // chargement police temperature
  text(temp, 138, 180); // affiche un texte
  textFont(police_hum_pression); 
  text(hum, 68, 329); // affiche un texte
  text(pression, 226, 329); // affiche un texte
}

//////////////// fonction appelée toute seule lorsque l'on reçois des infos sur le port série///////////////////
void serialEvent(Serial p) { 

  if (port_arduino.available()>0) { // si on reçoit qqchose sur le port série
    trame=port_arduino.readStringUntil(LF); //récupere la chaine de caractere jusqu'au retour chariot de println)
  }

  if (trame!=null) { // vérifie que l'on ne reçois pas n'importe quoi, enfin quelquechose

    String [] valeurs=trame.split("/"); // on découpe grace au séparateur, 
    // puis on alimente le tableau "valeurs"
    if (valeurs[0].equals("H") && valeurs.length==5) { // on vérifie que valeurs[0] du tableau est bien le caractere de début (H) et que la taille est de 5 lignes
      println("-----------------"); // on affiche dans la console un petit séparateur
      for (int i=1;i<valeurs.length-1;i++) { // on pars de 1 (on ne veux plus du caractere du début, et on s'arrete avant la fin car pas besoin du retour chariot LF
        println("valeurs["+ i+"] ==>  "+valeurs[i]); // on affiche dans la console les valeurs valeurs[1] = température, valeurs[2] = humidité, valeurs[3] à la pression
      } 
      // on passe dans les variables globales les valeurs reçues
      temp = valeurs[1] ; //ligne 1 du tableau "valeurs"
      hum = valeurs[2] ; //ligne 2 du tableau "valeurs"
      pression = valeurs[3] ; //ligne 3 du tableau "valeurs"
      // on enregistre une ligne dans le fichier
      enregistre(); // appelle la fonction enregistrer
      // ici pourquoi pas la fonction a créer 'envoyer au site web !//
    }
  }
}

/////////////// fonction qui enregistre /////////////////////:
void enregistre() { // fonction qui enregistre ligne par ligne (fonction lancée dès que l'on reçois une donnée sur le port série
  String heure = hour()+":"+minute()+":"+second(); // on forme l'heure
  String date = day()+"/"+month()+"/"+year(); // la date
  fichier.println(date+";"+heure+";"+temp + ";" +hum+";"+pression); // ici le séparateur est ";" , à prendre en compte lors de l'importation dans EXCEL ou openoffice
}

///////////////fonction qui finalise le fichier et qui quitte sur une pression de touche clavier///////////////////
void keyPressed() { // si une touche est pressée
  fichier.flush(); //on ecris dans le fichier 
  fichier.close(); // on ferme le fichier
  exit(); // on quitte le programme
}

