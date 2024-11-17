import wollok.game.*
import Boxeadores.*

object juego{
	var juegoIniciado = false

    //Pantalla del menu donde tocamos enter para pasar a elegir el nivel

	method iniciarMenu(){
		self.presentacionMenu()

		keyboard.enter().onPressDo {
			if(not juegoIniciado){
				game.removeVisual(imagenMenu)
				self.pantallaDificultad()
				juegoIniciado = true
			}
		}
	}

	method presentacionMenu(){
		game.title("Punch Out")
		game.height(15)
		game.width(18)
		game.addVisual(imagenMenu)
	}

    //Elegimos nivel

	method pantallaDificultad(){
		game.addVisual(imagenDificultad)

		keyboard.num1().onPressDo {
			game.removeVisual(imagenDificultad)
			nivel1.iniciarNivel()
		}

		keyboard.num2().onPressDo {
			game.removeVisual(imagenDificultad)
			nivel2.iniciarNivel()
		}
	}
	

    //Pantallas al terminar partida

	method pantallaVictoria(){
		game.clear()
		self.musicaVictoria()
		game.addVisual(imagenVictoria)
		juegoIniciado = false
	}
	
	method pantallaDerrota(){
		game.clear()
		self.musicaDerrota()
		game.addVisual(imagenDerrota)
		juegoIniciado = false
	}

    //Musica a sonar en sus respectivas pantallas

	method musicaMenu(){	
		const musicaMenu = game.sound("musica/01 Punch Out!! Theme.mp3")
        musicaMenu.shouldLoop(true)
		musicaMenu.play()
		musicaMenu.volume(0.5)
	}
	
	method musicaVictoria(){	
		const musicaGanaste = game.sound("musica/14 Bout Winner.mp3")
			musicaGanaste.play()
			musicaGanaste.volume(0.5)
	}
	
	method musicaDerrota(){
		const musicaPerdiste = game.sound("musica/12 You Lose.mp3")
			musicaPerdiste.play()
			musicaPerdiste.volume(0.5)
	}
}

// imagenes que vamos a mostrar en cada pantalla
    //***no es mejor manejar los fondos con game.boardGround() en vez de crear objetos por cada una?***
object imagenMenu{
	var property position = game.at(0,0)
	var property image = 'imagenes/imagenMenu.jpg'

}

object imagenDificultad{
	var property position = game.at(0,0)
	var property image = 'imagenes/imagenMenuDificultad.jpg'

}

object imagenDerrota{
	var property position = game.at(0,0)
	var property image = 'imagenes/imagenMenu.jpg'

}

object imagenVictoria{
	var property position = game.at(0,0)
	var property image = 'imagenes/imagenMenu.jpg'

}

//Creación de niveles
class Nivel{
	var property boxeadorRival
	var property ring

	method iniciarNivel(){
		game.boardGround("imagenes/" + ring + ".png") //al cargar el juego desde el nivel, se muestra el fondo correctamente, pero no se ve si se entra al nivel desde el menú (?)
		game.addVisual(boxeadorRival)
        self.jugador()
	}

	method jugador() {
		game.addVisual(boxeadorJugador)
		keyboard.z().onPressDo{boxeadorJugador.cambiarEstado(atacando)}
		keyboard.x().onPressDo{boxeadorJugador.cambiarEstado(cubriendo)}
		keyboard.c().onPressDo{boxeadorJugador.cambiarEstado(atacandoEspecial)}
	}
}

object nivel1 inherits Nivel{
    method initialize(){
        boxeadorRival = rocky
        ring  = "ring1"
    }
}

object nivel2 inherits Nivel{
    method initialize(){
        boxeadorRival = tyson
        ring  = "ring1" //cambiar a otro tipo para cada nivel
    }
}