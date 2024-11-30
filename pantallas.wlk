import juego.*
import Boxeadores.*
import imagenYSonido.*
//Pantallas
class Pantalla {
    var property tipo = ""
    method mostrar()
    method ocultar() {game.removeVisual(self) game.removeVisual(tipo)}
}

object pantallaCarga inherits Pantalla {
    method initialize() {tipo = imagenCarga}
    override method mostrar() {
        game.addVisual(tipo)

        keyboard.enter().onPressDo {
            if(gestorPantallas.pantallaActual() != self) {self.error("") }
            gestorPantallas.mostrarPantalla(pantallaMenu)
        }
    }
}

object pantallaMenu inherits Pantalla {
    method initialize() {tipo = imagenMenu}
    override method mostrar() {
        game.addVisual(tipo)
        gestorSonidos.musicaMenu()

        //Controles de pantalla
        keyboard.enter().onPressDo {
            if(gestorPantallas.pantallaActual() != self) {self.error("") }
            gestorSonidos.sonidoEnter()
            game.schedule(1000, {
                gestorPantallas.mostrarPantalla(pantallaDificultad)
            })
        }
    }
}

object pantallaDificultad inherits Pantalla {
    var nivelElegido = null
    var cargandoNivel = false

    method initialize() {tipo = imagenDificultad}

    method cargarNivel() {
        gestorSonidos.sonidoEnter()
        game.schedule(1000, {
            pantallaNivel.tipoNivel(nivelElegido)
            gestorPantallas.mostrarPantalla(pantallaNivel)
            cargandoNivel = false
        })
    }
    override method mostrar() {
        game.addVisual(tipo)
        gestorSonidos.musicaDificultad()

        //Controles de pantalla
        keyboard.num1().onPressDo ({
            if(gestorPantallas.pantallaActual() != self || cargandoNivel) {self.error("") }
            nivelElegido = nivel1
            cargandoNivel = true
            self.cargarNivel()
        })
        keyboard.num2().onPressDo ({
            if(gestorPantallas.pantallaActual() != self || cargandoNivel) {self.error("") }
            nivelElegido = nivel2
            cargandoNivel = true
            self.cargarNivel()
        })
        keyboard.num3().onPressDo ({
            if(gestorPantallas.pantallaActual() != self || cargandoNivel) {self.error("") }
            nivelElegido = nivel3
            cargandoNivel = true
            self.cargarNivel()
        })
    }
}

object pantallaVictoria inherits Pantalla {
    method initialize() {tipo = imagenVictoria}
    override method mostrar() {
        game.addVisual(tipo)
        gestorSonidos.musicaVictoria()

        game.schedule(5000, {
            gestorPantallas.mostrarPantalla(pantallaDificultad)
        })
    }
}

object pantallaDerrota inherits Pantalla {
    method initialize() {tipo = imagenDerrota}
    override method mostrar() {
        game.addVisual(tipo)
        gestorSonidos.musicaDerrota()
        game.schedule(5000, {
            gestorPantallas.mostrarPantalla(pantallaDificultad)
        })
    }
}

object pantallaNivel inherits Pantalla {
    var property tipoNivel = nivel1
    var property boxeadorRival = null
    const accionesRival = []
    var pantallaFinal = null

    method initialize() {tipo = pantallaRing}

    override method mostrar() {
        boxeadorRival = tipoNivel.rival()

        self.limpiarVisuales()
        boxeadorJugador.reiniciar()
        boxeadorRival.reiniciar()
        mario.reiniciar()

        game.addVisual(tipo)
        game.addVisual(boxeadorRival)
        game.addVisual(boxeadorJugador)
        game.addVisual(vidaJugador)

        if(!mario.sePuedePelear() && boxeadorRival.vida() == 100 && boxeadorJugador.vida() == 100){
            game.addVisual(mario)
            mario.contar()
        }

        vidaOponente.oponente(boxeadorRival)
        game.addVisual(vidaOponente)

        //Especificaciones por nivel
        tipoNivel.cambiarFondo()
        accionesRival.clear()
        accionesRival.addAll(tipoNivel.accionesRival())

        gestorSonidos.musicaPelea()

        // Establecer rival del jugador
        boxeadorJugador.rival(boxeadorRival)

        //Inicia la IA del rival
        self.iniciarIARival()

        //Controles de pantalla
        keyboard.z().onPressDo {  
            if(gestorPantallas.pantallaActual() != self || !mario.sePuedePelear()) {self.error("") }   
            boxeadorJugador.atacar()
        }
        keyboard.c().onPressDo {
            if(gestorPantallas.pantallaActual() != self || !mario.sePuedePelear()) {self.error("") }
            boxeadorJugador.atacarEspecial()
        }
        keyboard.x().onPressDo {
            if(gestorPantallas.pantallaActual() != self || !mario.sePuedePelear()) {self.error("") }
            boxeadorJugador.cubrirse()
        }
    }

    method iniciarIARival() {
        game.onTick(1000, "iaRival", {
            if (boxeadorRival.vida() > 0 && boxeadorJugador.vida() > 0 && mario.sePuedePelear()) {
                self.decidirAccionDelRival()
            }
        })
    }

    method decidirAccionDelRival(){
        if(boxeadorRival.vida() <= 0) {boxeadorRival.estado(derrota) self.error("") } 
        accionesRival.findOrDefault({a => a.esEjecutable()}, accionDescansar).ejecutar(boxeadorRival)
    }

    // Método para verificar la vida de ambos boxeadores
    method verificarVida() {
        if (boxeadorRival.vida() <= 0) {
            boxeadorJugador.estado(victoria)
            boxeadorRival.estado(derrota)
            pantallaFinal = pantallaVictoria
            gestorSonidos.sonidoCampana()
            game.onTick(500, "tribunaAlocada", {tribunaLoca.alocarse()})
            gestorSonidos.pararMusica()
            gestorSonidos.sonidoTribuna()

            game.schedule(4500,
               {self.reiniciarNivel()}
            )
            
        } else if (boxeadorJugador.vida() <= 0) {
			boxeadorRival.estado(victoria)
            boxeadorJugador.estado(derrota)
            pantallaFinal = pantallaDerrota
            gestorSonidos.sonidoCampana()
            game.addVisual(tribunaLoca)
            gestorSonidos.pararMusica()
            gestorSonidos.sonidoTribuna()

            game.schedule(4500,
                {self.reiniciarNivel()}
            )           
        }
    }

    method reiniciarNivel(){
        if(gestorPantallas.pantallaActual() != self || !mario.sePuedePelear()) {self.error("") } 
        game.removeTickEvent("iaRival")
        game.removeTickEvent("tribunaAlocada")
        self.limpiarVisuales()
        mario.reiniciar()
        gestorPantallas.mostrarPantalla(pantallaFinal)
    }

    method limpiarVisuales() {
        game.removeVisual(boxeadorJugador)
        game.removeVisual(boxeadorRival)
        game.removeVisual(vidaJugador)
        game.removeVisual(vidaOponente)
        game.removeVisual(tipo)
        game.removeVisual(tribunaLoca)
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