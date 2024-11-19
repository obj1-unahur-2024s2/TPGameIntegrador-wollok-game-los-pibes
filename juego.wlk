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
            game.schedule(1000, {
                if(not juegoIniciado){
                    game.removeVisual(imagenMenu)
                    self.pantallaDificultad()
                    juegoIniciado = true
                }}
            )
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
            reproducir.musicaEnter()
            game.schedule(1000,
               {game.removeVisual(imagenDificultad)
                nivel1.iniciarNivel()}   
            )     
		}

		keyboard.num2().onPressDo {
            reproducir.pararLaMusica()
            reproducir.musicaEnter()
            game.schedule(1000,
               {game.removeVisual(imagenDificultad)
                nivel2.iniciarNivel()}   
            )          
		}

        keyboard.num3().onPressDo {
            reproducir.pararLaMusica()
            reproducir.musicaEnter()
            game.schedule(1000,
               {game.removeVisual(imagenDificultad)
                nivel3.iniciarNivel()}   
            )      
		}
	}
	

    //Pantallas al terminar partida

	method pantallaVictoria(){
        reproducir.pararLaMusica()
		reproducir.musicaVictoria()
		game.addVisual(imagenVictoria)
		juegoIniciado = false
	}
	
	method pantallaDerrota(){
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
        game.schedule(500, {menu.play() menu.shouldLoop(true)})
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

// Imagenes normalizadas para elegir los fondos

class Imagen {
    var property tipo = ""
    var property position = game.at(0, 0)
    method image() = "imagen" + self.tipo() + ".png" 
}

object imagenMenu inherits Imagen{ 
    method initialize() {tipo = "Menu"}
}

object imagenDificultad inherits Imagen{
	method initialize() {tipo = "MenuDificultad"}
}

object imagenDerrota inherits Imagen{
	method initialize() {tipo = "PantallaDerrota"}
}

object imagenVictoria inherits Imagen{
    method initialize() {tipo = "PantallaVictoria"}
}

object pantallaRing inherits Imagen{
    override method image() = "ring" + self.tipo() + ".png"
}


//Creación de niveles
class Nivel {
    var property boxeadorRival
    const accionesRival = []

    method iniciarNivel() {
        game.addVisual(pantallaRing)
        game.addVisual(boxeadorRival)
        game.addVisual(boxeadorJugador)
        reproducir.musicaPelea()

        // Establecer rival del jugador
        boxeadorJugador.rival(boxeadorRival)

        //Inicia la IA del rival
        self.iniciarIARival()

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
            boxeadorJugador.cubrirse()
        }
    }

    method iniciarIARival() {
        game.onTick(1000, "iaRival", {
            if (boxeadorRival.vida() > 0 && boxeadorJugador.vida() > 0) {
                self.decidirAccionDelRival()
                self.verificarVida() //¿fuera?
            }
        })
    }

    method decidirAccionDelRival(){
        accionesRival.findOrDefault({a => a.esEjecutable()}, accionDescansar).ejecutar(boxeadorRival)
    }

    // Método para verificar la vida de ambos boxeadores
    method verificarVida() {
        if (boxeadorRival.vida() <= 0) { 
            boxeadorJugador.estado(victoria)
            boxeadorRival.estado(derrota)
            game.schedule(1000,
               {juego.pantallaVictoria()
                game.schedule(5000,{game.stop()})}
            )
            
        } else if (boxeadorJugador.vida() <= 0) {
			boxeadorRival.estado(victoria)
            boxeadorJugador.estado(derrota)
            game.schedule(1000,
                {juego.pantallaDerrota()
                game.schedule(5000,{game.stop()})}
            )           
        }
    }
}

object nivel1 inherits Nivel {
    method initialize() {
        boxeadorRival = joe
        accionesRival.add(new AccionAtacar(probabilidad=30))
    }

    override method iniciarNivel(){
        super()
        pantallaRing.tipo(1)
    }
}

object nivel2 inherits Nivel {
    method initialize() {
        boxeadorRival = rocky
        accionesRival.addAll([new AccionAtacar(probabilidad=35), new AccionCubrirse(probabilidad=10)])
    }

    override method iniciarNivel(){
        super()
        pantallaRing.tipo(2)
    }
}

object nivel3 inherits Nivel {
    method initialize() {
        boxeadorRival = tyson
        accionesRival.addAll([new AccionAtacar(probabilidad=40), new AccionCubrirse(probabilidad=15), new AccionAtacarEspecial(probabilidad=20)])
    }

    override method iniciarNivel(){
        super()
        pantallaRing.tipo(3)
    }
}

object talvez {
    method seaCierto(porcentaje) = 0.randomUpTo(1) * 100 < porcentaje
}

//Acciones del rival para la IA
class AccionRival {
    var probabilidad

    method ejecutar(boxeadorRival)

    method esEjecutable() = talvez.seaCierto(probabilidad)
}

class AccionAtacar inherits AccionRival {
    override method ejecutar(boxeadorRival) {
        boxeadorRival.atacar()
    }
}

class AccionCubrirse inherits AccionRival {
    override method ejecutar(boxeadorRival) {
        boxeadorRival.cubrirse()
    }
}

class AccionAtacarEspecial inherits AccionRival {
    override method ejecutar(boxeadorRival) {
        boxeadorRival.atacarEspecial()
    }
}

object accionDescansar inherits AccionRival {
    method initialize(){
        probabilidad = 100
    }

    override method ejecutar(boxeadorRival) {
        boxeadorRival.descansar()
    }
}