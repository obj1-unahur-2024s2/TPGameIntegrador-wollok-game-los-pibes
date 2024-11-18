import wollok.game.*
import Boxeadores.*

object juego{
	var juegoIniciado = false

    //Pantalla del menu donde tocamos enter para pasar a elegir el nivel

	method iniciarMenu(){
		self.presentacionMenu()
        reproducir.musicaMenu()
		keyboard.enter().onPressDo {   
            reproducir.pararLaMusica()
            reproducir.musicaEnter()
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
        reproducir.musicaDificultad()
        

		keyboard.num1().onPressDo {
            reproducir.pararLaMusica()
			game.removeVisual(imagenDificultad)
			nivel1.iniciarNivel()        
		}

		keyboard.num2().onPressDo {
            reproducir.pararLaMusica()
			game.removeVisual(imagenDificultad)
			nivel2.iniciarNivel()        
		}

        keyboard.num3().onPressDo {
            reproducir.pararLaMusica()
			game.removeVisual(imagenDificultad)
			nivel3.iniciarNivel()     
		}
	}
	

    //Pantallas al terminar partida

	method pantallaVictoria(){
		game.clear()
        reproducir.pararLaMusica()
		reproducir.musicaVictoria()
		game.addVisual(imagenVictoria)
		juegoIniciado = false
	}
	
	method pantallaDerrota(){
		game.clear()
        reproducir.pararLaMusica()
		reproducir.musicaDerrota()
		game.addVisual(imagenDerrota)
		juegoIniciado = false
	}
}

//Músicas
object reproducir{
    var menu = game.sound("01 Punch Out!! Theme.mp3")
    
    
    const golpe = game.sound("m28 (se) Punching Opponent.mp3")
    
    method musicaMenu() {
        game.schedule(500, {menu.play() menu.shouldLoop(true)})
        }
    method musicaEnter() {
        menu = game.sound("21 (se) Punching Title Name.mp3")
        menu.play()
        }
    method musicaDificultad() {
        menu = game.sound("18 Warming Up with Doc.mp3")
        game.schedule(1300, {menu.play() menu.shouldLoop(true)})
        menu.volume(0.4)
        }     
    method musicaPelea() {
        menu = game.sound("10 Match BGM.mp3")
        game.schedule(500, {menu.play() menu.shouldLoop(true)})
        }
    method musicaVictoria() {
        menu = game.sound("14 Bout Winner.mp3")
        game.schedule(500, {menu.play()})
        }
    method musicaDerrota() {
        menu = game.sound("12 You Lose.mp3")
        game.schedule(500, {menu.play()})
        }

    method sonidoGolpe() {golpe.play()}
    method pararLaMusica() {
      menu.stop()
    }
}

// imagenes que vamos a mostrar en cada pantalla
    //***¿No es mejor manejar los fondos con game.boardGround() en vez de crear objetos por cada una?***

class Imagen {
  var property tipo = ""
    var property position = game.at(0, 0)
    var property image = "imagen" + self.tipo() + ".png" 
}

object imagenMenu inherits Imagen{
	override method tipo() = "Menu"
}

object imagenDificultad inherits Imagen{
	override method tipo() = "MenuDificultad"
}

object imagenDerrota inherits Imagen{
	override method tipo() = "PantallaDerrota"
}

object imagenVictoria inherits Imagen{
    override method tipo() = "PantallaVictoria"
}


//Creación de niveles
class Nivel {
    var property boxeadorRival
    var property ring

    method iniciarNivel() {
        game.addVisual(ring)
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

        // Iniciar comportamiento del rival
        self.ataqueDelRival()
    }

    method ataqueDelRival() {
        // Este método está pensado para ser sobrescrito en cada nivel
    }

    // Método para verificar la vida de ambos boxeadores
    method verificarVida() {
        if (boxeadorRival.vida() == 0) {
            game.removeVisual(boxeadorRival)
            boxeadorJugador.cambiarEstado(victoria)
            juego.pantallaVictoria()
            game.stop()
            
        } else if (boxeadorJugador.vida() == 0) {
            game.removeVisual(boxeadorJugador)
			boxeadorRival.cambiarEstado(victoria)
            juego.pantallaDerrota()
            game.stop()
        }
    }
}




object nivel1 inherits Nivel {
    method initialize() {
        boxeadorRival = joe
        ring = ring1
    }

    override method ataqueDelRival() {
        game.schedule(1000, {
            if (boxeadorRival.vida() > 0 && boxeadorJugador.vida() > 0) {
                if (talvez.seaCierto(30)) { // 30% de probabilidad de atacar
                    boxeadorRival.atacar()
                }
                self.verificarVida()
                self.ataqueDelRival() // Volver a llamar para repetir
            }
        })
    }
}



object nivel2 inherits Nivel {
    method initialize() {
        boxeadorRival = rocky
        ring = ring2
    }

    override method ataqueDelRival() {
        game.schedule(1000, {
            if (boxeadorRival.vida() > 0 && boxeadorJugador.vida() > 0) {
                if (talvez.seaCierto(35)) { // 20% de probabilidad de atacar
                    boxeadorRival.atacar()
                }
                if (talvez.seaCierto(10)) { // 10% de probabilidad de cubrirse
                    boxeadorRival.cambiarEstado(cubriendo)
                }
                self.verificarVida()
                self.ataqueDelRival() // Volver a llamar para repetir
            }
        })
    }
}


object nivel3 inherits Nivel {
    method initialize() {
        boxeadorRival = tyson
        ring = ring3
    }

    override method ataqueDelRival() {
        game.schedule(1000, {
            if (boxeadorRival.vida() > 0 && boxeadorJugador.vida() > 0) {
                if (talvez.seaCierto(40)) { // 30% de probabilidad de atacar
                    boxeadorRival.atacar()
                }
                if (talvez.seaCierto(15)) { // 15% de probabilidad de cubrirse
                    boxeadorRival.cambiarEstado(cubriendo)
                }
                if (talvez.seaCierto(20)) { // 20% de probabilidad de ataque especial
                    boxeadorRival.atacarEspecial()
                }
                self.verificarVida()
                self.ataqueDelRival() // Volver a llamar para repetir
            }
        })
    }
}


object talvez {
    method seaCierto(porcentaje) = 0.randomUpTo(1) * 100 < porcentaje
}

class Ring{
    var property valor = 0
    var property position = game.at(0, 0)
    var property image = "ring" + self.valor() + ".png"  
}

object ring1 inherits Ring {
  override method valor() = "1"
}
object ring2 inherits Ring {
    override method valor() = "2"
}
object ring3 inherits Ring {
    override method valor() = "3"
}

