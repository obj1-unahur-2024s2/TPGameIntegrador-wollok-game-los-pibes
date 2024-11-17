import wollok.game.*
import Boxeadores.*

object juego{

	var property nivel = 0
	var property juegoIniciado = false

// pantalla del menu donde tocamos enter para pasar a elegir el nivel

	method iniciarMenu(){
		self.presentacionMenu()
		keyboard.enter().onPressDo {
			if(not self.juegoIniciado()){
				game.removeVisual(imagenMenu)
				self.pantallaDificultad()
				self.juegoIniciado(true)
			}
		}
	}

	method presentacionMenu(){
		game.title("Punch Out")
		game.height(15)
		game.width(18)
		game.addVisual(imagenMenu)
	}

//elegimos nivel

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
	

// pantallas al terminar partida

	method pantallaVictoria(){
		game.clear()
		self.musicaVictoria()
		game.addVisual(imagenVictoria)
		self.juegoIniciado(false)
	}
	
	method pantallaDerrota(){
		game.clear()
		self.musicaDerrota()
		game.addVisual(imagenDerrota)
		self.juegoIniciado(false)
	}
// musica a sonar en sus respectivas pantallas

	method musicaMenu(){	
		const musicaMenu = game.sound("musica/01 Punch Out!! Theme.mp3")
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
object imagenMenu{
	var property position = game.at(0,0)
	var property image = 'imagenes/imagenMenu.jpg'

}

object imagenDificultad{
	var property position = game.at(0,0)
	var property image = 'imagenes/imagenMenu.jpg'

}

object imagenDerrota{
	var property position = game.at(0,0)
	var property image = 'imagenes/imagenMenu.jpg'

}

object imagenVictoria{
	var property position = game.at(0,0)
	var property image = 'imagenes/imagenMenu.jpg'

}
// clase para crear los niveles
class Nivel{
	var property boxeador

	method iniciarNivel(){
		self.iniciar()
		game.addVisual(boxeador)
	}

	method iniciar(){
		game.boardGround("ring1.png")
		self.personajes()		
	}
	method personajes() {
		game.addVisual(boxeadorJugador)
		keyboard.z().onPressDo{boxeadorJugador.cambiarEstado(atacando)}
		keyboard.x().onPressDo{boxeadorJugador.cambiarEstado(cubriendo)}
		keyboard.c().onPressDo{boxeadorJugador.cambiarEstado(atacandoEspecial)}
	}
}

const nivel1 = new Nivel(boxeador = rocky)
const nivel2 = new Nivel(boxeador = tyson)