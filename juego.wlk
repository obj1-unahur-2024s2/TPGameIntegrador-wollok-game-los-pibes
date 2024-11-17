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

	method musicaPelea(){	
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
	var property image = 'imagenMenu.jpg'

}

object imagenDificultad{
	var property position = game.at(0,0)
	var property image = 'imagenMenuDificultad.jpg'

}

object imagenDerrota{
	var property position = game.at(0,0)
	var property image = 'imagenMenu.jpg'

}

object imagenVictoria{
	var property position = game.at(0,0)
	var property image = 'imagenMenu.jpg'

}

//Creación de niveles
class Nivel {
    var property boxeadorRival
    var property ring

    method iniciarNivel() {
        game.boardGround(ring)
        game.addVisual(boxeadorRival)
        game.addVisual(boxeadorJugador)

        // Establecer rival del jugador
        boxeadorJugador.rival(boxeadorRival)

        // Asignar controles para atacar y cubrirse
        keyboard.z().onPressDo {
            boxeadorJugador.atacar()
            self.verificarVida()
        }
        keyboard.c().onPressDo {
            boxeadorJugador.atacarEspecial()
            self.verificarVida()
        }
        keyboard.x().onPressDo {
            boxeadorJugador.cambiarEstado(cubriendo)
        }
    }

    // Método para verificar la vida de ambos boxeadores
    method verificarVida() {
        if (boxeadorRival.vida() == 0) {
            game.removeVisual(boxeadorRival)
            boxeadorJugador.cambiarEstado(victoria)
			game.stop()
        } else if (boxeadorJugador.vida() == 0) {
            game.removeVisual(boxeadorJugador)
			game.stop()
        }
    }
}


object nivel1 inherits Nivel{
    method initialize(){
        boxeadorRival = rocky
        ring  = "ring1.jpg"
    }
}

object nivel2 inherits Nivel{
    method initialize(){
        boxeadorRival = tyson
        ring  = "ring1.jpg" //cambiar a otro tipo para cada nivel
    }
}