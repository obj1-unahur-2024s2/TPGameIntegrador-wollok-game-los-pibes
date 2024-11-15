import wollok.game.*
import pantallas.*

object juego{

	var property nivel = 0
	var property juegoIniciado = false


	method iniciarMenu(){
		self.presentacionMenu()
		keyboard.enter().onPressDo {
			if(not self.juegoIniciado()){
				game.removeVisual(imagenMenu)
				self.iniciarJuego()
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

	method iniciarJuego(){
		self.pantallaDificultad()
	}


	method pantallaDificultad(){
		game.addVisual(imagenDificultad)
		keyboard.num1().onPressDo {
		}
		keyboard.num2().onPressDo {
			
		}
		keyboard.num3().onPressDo {
			
		}
	}
	
	
	method pantallaVictoria(){
		self.finalizar()
		self.musicaVictoria()
		game.addVisual(imagenVictoria)
		self.juegoIniciado(false)
	}
	
	method pantallaDerrota(){
		self.finalizar()
		self.musicaDerrota()
		game.addVisual(imagenDerrota)
		self.juegoIniciado(false)
	}

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