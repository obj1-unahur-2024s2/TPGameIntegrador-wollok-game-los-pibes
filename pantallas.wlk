import juego.*
import Boxeadores.*

//Pantallas
class Pantalla {
    var property tipo = ""
    method mostrar()
    method ocultar() {game.removeVisual(self) game.removeVisual(tipo)}
}

object pantallaMenu inherits Pantalla {
    method initialize() {tipo = imagenMenu}
    override method mostrar() {
        game.addVisual(tipo)
        reproducir.musicaMenu()
        keyboard.enter().onPressDo {
            if(gestorPantallas.pantallaActual() != self) {self.error("No se puede usar esa tecla en esta pantalla") }
            reproducir.pararLaMusica()
            reproducir.musicaEnter()
            game.schedule(1000, {
                gestorPantallas.mostrarPantalla(pantallaDificultad)
            })
        }
    }
}

object pantallaDificultad inherits Pantalla {
    var nivelElegido = null

    method initialize() {tipo = imagenDificultad}

    override method mostrar() {
        game.addVisual(tipo)
        reproducir.musicaDificultad()

        keyboard.num1().onPressDo {
            if(gestorPantallas.pantallaActual() != self) {self.error("No se puede usar esa tecla en esta pantalla") }
            nivelElegido = nivel1
            self.cargarNivel()
        }
        keyboard.num2().onPressDo {
            if(gestorPantallas.pantallaActual() != self) {self.error("No se puede usar esa tecla en esta pantalla") }
            nivelElegido = nivel2
            self.cargarNivel()
        }
        keyboard.num3().onPressDo {
            if(gestorPantallas.pantallaActual() != self) {self.error("No se puede usar esa tecla en esta pantalla") }
            nivelElegido = nivel3
            self.cargarNivel()
        }
    }

    method cargarNivel() {
        reproducir.pararLaMusica()
        reproducir.musicaEnter()
        game.schedule(1000, {
            pantallaNivel.tipoNivel(nivelElegido)
            gestorPantallas.mostrarPantalla(pantallaNivel)
        })
    }
}

object pantallaVictoria inherits Pantalla {
    method initialize() {tipo = imagenVictoria}
    override method mostrar() {
        game.addVisual(tipo)
        reproducir.pararLaMusica()
        reproducir.musicaVictoria()

        game.schedule(5000, {
            reproducir.pararLaMusica()
            gestorPantallas.mostrarPantalla(pantallaDificultad) // Volver a la selección de niveles
        })
    }
}

object pantallaDerrota inherits Pantalla {
    method initialize() {tipo = imagenDerrota}
    override method mostrar() {
        game.addVisual(tipo)
        reproducir.pararLaMusica()
        reproducir.musicaDerrota()

        game.schedule(5000, {
            reproducir.pararLaMusica()
            gestorPantallas.mostrarPantalla(pantallaDificultad) // Volver a la selección de niveles
        })
    }
}

object pantallaNivel inherits Pantalla {
    var property tipoNivel = nivel1
    var boxeadorRival = null
    const accionesRival = []
    var pantallaFinal = null

    method initialize() {tipo = pantallaRing}

    override method mostrar() {
        boxeadorRival = tipoNivel.rival()

        self.limpiarVisuales()
        game.addVisual(tipo)
        game.addVisual(boxeadorRival)
        game.addVisual(boxeadorJugador)
        game.addVisual(vidaJugador)

        vidaOponente.oponente(boxeadorRival)
        game.addVisual(vidaOponente)

        //Especificaciones por nivel
        tipoNivel.cambiarFondo()
        accionesRival.clear()
        accionesRival.addAll(tipoNivel.accionesRival())

        reproducir.musicaPelea()

        // Establecer rival del jugador
        boxeadorJugador.rival(boxeadorRival)

        //Inicia la IA del rival
        self.iniciarIARival()

        // Asignar controles para atacar y cubrirse
        keyboard.z().onPressDo {  
            if(gestorPantallas.pantallaActual() != self) {self.error("No se puede usar esa tecla en esta pantalla") }   
            boxeadorJugador.atacar()
            self.verificarVida()
        }
        keyboard.c().onPressDo {
            if(gestorPantallas.pantallaActual() != self) {self.error("No se puede usar esa tecla en esta pantalla") }
            boxeadorJugador.atacarEspecial()
            self.verificarVida()
        }
        keyboard.x().onPressDo {
            if(gestorPantallas.pantallaActual() != self) {self.error("No se puede usar esa tecla en esta pantalla") }
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
            pantallaFinal = pantallaVictoria

            game.schedule(1000,
               {self.reiniciarNivel()}
            )
            
        } else if (boxeadorJugador.vida() <= 0) {
			boxeadorRival.estado(victoria)
            boxeadorJugador.estado(derrota)
            pantallaFinal = pantallaDerrota

            game.schedule(1000,
                {self.reiniciarNivel()}
            )           
        }
    }

    method reiniciarNivel(){
        boxeadorJugador.reiniciar()
        boxeadorRival.reiniciar()
        self.limpiarVisuales()

        game.removeTickEvent("iaRival")
        gestorPantallas.mostrarPantalla(pantallaFinal)
    }

    method limpiarVisuales() {
        game.removeVisual(boxeadorJugador)
        game.removeVisual(boxeadorRival)
        game.removeVisual(vidaJugador)
        game.removeVisual(vidaOponente)
        game.removeVisual(tipo)
    }
}

object nivel1{
    method rival() = joe
    method accionesRival() = [new AccionAtacar(probabilidad=35), new AccionCubrirse(probabilidad=25)]
    method cambiarFondo() {pantallaRing.tipo(1)}
}

object nivel2 {
    method rival() = rocky
    method accionesRival() = [new AccionAtacar(probabilidad=45), new AccionCubrirse(probabilidad=35)]
    method cambiarFondo() {pantallaRing.tipo(2)}
}

object nivel3 {
    method rival() = tyson
    method accionesRival() = [new AccionAtacar(probabilidad=75), new AccionCubrirse(probabilidad=60), new AccionAtacarEspecial(probabilidad=20)]
    method cambiarFondo() {pantallaRing.tipo(3)}
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

//Vidas

object vidaJugador {
  method position() = game.at(2, 13)
  method image() = "vida" + boxeadorJugador.vida() + ".png"
}

object vidaOponente {
    var property oponente = joe
    method position() = game.at(13, 13)
    method image() = "vida" + self.oponente().vida() + ".png"
}

//Músicas
object reproducir{
    var mscActual = game.sound("01 Punch Out!! Theme.mp3")
    
    const golpe = game.sound("m28 (se) Punching Opponent.mp3")
    
    method musicaMenu() {
        game.schedule(500, {mscActual.play() mscActual.shouldLoop(true)})
        }
    method musicaEnter() {
        mscActual = game.sound("21 (se) Punching Title Name.mp3")
        mscActual.play()
        }
    method musicaDificultad() {
        mscActual = game.sound("18 Warming Up with Doc.mp3")
        game.schedule(500, {mscActual.play() mscActual.shouldLoop(true)})
        mscActual.volume(0.4)
        }     
    method musicaPelea() {
        mscActual = game.sound("10 Match BGM.mp3")
        game.schedule(500, {mscActual.play() mscActual.shouldLoop(true)})
        }
    method musicaVictoria() {
        mscActual = game.sound("14 Bout Winner.mp3")
        game.schedule(500, {mscActual.play()})
        }
    method musicaDerrota() {
        mscActual = game.sound("12 You Lose.mp3")
        game.schedule(500, {mscActual.play()})
        }

    method sonidoGolpe() {golpe.play()}
    method pararLaMusica() {
      mscActual.stop()
    }
}

// Imágenes

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