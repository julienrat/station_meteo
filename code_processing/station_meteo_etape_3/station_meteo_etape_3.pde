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
int LF=10; // valeur du retour chariot en ASCII


void setup() { // fonction setup, executée une seule fois au lancement du programme
  size(400, 400); //taille de la fenetre en pixels
  println(Serial.list()); // liste la liste des ports disponibles
  //connexion à arduino //
  port_arduino=new Serial(this, Serial.list()[index_port], vitesse); 
  ///////////////////////
  fichier = createWriter("enregistrements.csv"); // on cree un fichier
  fichier.println("Date;Heure;Température;Humidité;Pression"); // on ecris la première ligne du tableau
}

////////////////////////////////////////////////////////////////////
/* la fonction draw() est similaire à la fonction loop dans arduino, 
 elle tourne en boucle, elle sera interrompue par la fonction serialEvent(),
 puis reprendra sa route
 */
////////////////////////////////////////////////////////////////////

void draw() { // c'est moche, la suite dans l'etape 4 ;-)
  fill(0); // couleur noire
  rect(0, 0, 400, 400); // un rectangle pour le raffraichissement de la fenetre
  fill(0, 255, 0); // couleur verte
  textSize(32); // taille du texte
  text("Valeur reçue :", 100, 100); // affiche un texte
  textSize(12); // on réduit la taille du texte
  text("valeur 1 : ", 10, 200); // affiche un texte
  text(temp, 100, 200); // affiche un texte
  text("valeur 2 : ", 10, 250); // affiche un texte
  text(hum, 100, 250); // affiche un texte
  text("valeur 3 : ", 10, 300); // affiche un texte
  text(pression, 100, 300); // affiche un texte
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

