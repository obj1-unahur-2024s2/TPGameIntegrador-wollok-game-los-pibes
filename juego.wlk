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
        game.cellSize(16)

		game.height(15)
		game.width(16)

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

        keyboard.num3().onPressDo {
			game.removeVisual(imagenDificultad)
			nivel3.iniciarNivel()
		}
	}
	

    //Pantallas al terminar partida

	method pantallaVictoria(){
		game.clear()
		reproducirMusica.victoria()
		game.addVisual(imagenVictoria)
		juegoIniciado = false
	}
	
	method pantallaDerrota(){
		game.clear()
		reproducirMusica.derrota()
		game.addVisual(imagenDerrota)
		juegoIniciado = false
	}
}

//Músicas
object reproducir{
    const menu = game.sound("musica/01 Punch Out!! Theme.mp3")
    const pelea = game.sound("musica/10 Match BGM.mp3")
    const victoria = game.sound("musica/14 Bout Winner.mp3")
    const derrota = game.sound("musica/12 You Lose.mp3")
    
    const golpe = game.sound("musica/28 (se) Punching Opponent.mp3")
    
    method musicaMenu() {menu.play() menu.shouldLoop(true)}
    method musicaPelea() {pelea.play() pelea.shouldLoop(true)}
    method musicaVictoria() {victoria.play() }
    method musicaDerrota() {derrota.play() }

    method sonidoGolpe() {golpe.play() }
}

// imagenes que vamos a mostrar en cada pantalla
    //***¿No es mejor manejar los fondos con game.boardGround() en vez de crear objetos por cada una?***

object imagenMenu{
	var property position = game.at(0,0)
	var property image = 'imagenMenu.png'

}

object imagenDificultad{
	var property position = game.at(0,0)
	var property image = 'imagenMenuDificultad.png'

}

object imagenDerrota{
	var property position = game.at(0,0)
	var property image = 'pantallaDerrota.png'

}

object imagenVictoria{
	var property position = game.at(0,0)
	var property image = 'pantallaVictoria.png'

}

//Creación de niveles
class Nivel {
    var property boxeadorRival
    var property ring

    method iniciarNivel() {
        game.boardGround(ring)
        game.addVisual(boxeadorRival)
        game.addVisual(boxeadorJugador)
        reproducir.musicaPelea()

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
        boxeadorRival = joe
        ring  = "ring1.png"
    }
}

object nivel2 inherits Nivel{
    method initialize(){
        boxeadorRival = rocky
        ring  = "ring2.png"
    }
}

object nivel3 inherits Nivel{
    method initialize(){
        boxeadorRival = tyson
        ring  = "ring3.png" 
    }
}