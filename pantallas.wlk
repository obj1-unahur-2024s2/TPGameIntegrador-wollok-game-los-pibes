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
            gestorSonidos.pararMusica()
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
            gestorSonidos.pararMusica()
            nivelElegido = nivel1
            cargandoNivel = true
            self.cargarNivel()
        })
        keyboard.num2().onPressDo ({
            if(gestorPantallas.pantallaActual() != self || cargandoNivel) {self.error("") }
            gestorSonidos.pararMusica()
            nivelElegido = nivel2
            cargandoNivel = true
            self.cargarNivel()
        })
        keyboard.num3().onPressDo ({
            if(gestorPantallas.pantallaActual() != self || cargandoNivel) {self.error("") }
            gestorSonidos.pararMusica()
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

        game.schedule(4400, {
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
    var hayPermisoEspecial = false

    method initialize() {tipo = pantallaRing}

    override method mostrar() {
        const imagenVersus = tipoNivel.imagenVersus()
        game.addVisual(imagenVersus)
        gestorSonidos.musicaComienzaNivel()
        game.schedule(4000, {self.iniciarNivel() game.removeVisual(imagenVersus)}) 
    }
    
    method iniciarNivel() {
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
            game.schedule(1000, {mario.contar()})
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
        boxeadorJugador.poder(tipoNivel.poderJugador())

        //Inicia la IA del rival y permiso de ataque especial
        self.iniciarIARival()
        self.iniciarPermisoEspecial()

        //Controles de pantalla
        keyboard.z().onPressDo {  
            if(gestorPantallas.pantallaActual() != self || !mario.sePuedePelear() || !boxeadorJugador.estaQuieto()) {self.error("") }   
            
            const rivalSeCubre = (0.randomUpTo(3)).round()
            if(rivalSeCubre > 1) {boxeadorRival.cubrirse()}
            boxeadorJugador.atacar()
        }
        keyboard.x().onPressDo {
            if(gestorPantallas.pantallaActual() != self || !mario.sePuedePelear()) {self.error("") }
            boxeadorJugador.cubrirse()
        }
        keyboard.c().onPressDo {
            if(gestorPantallas.pantallaActual() != self || !mario.sePuedePelear() || !self.jugadoPuedeAtacarEspecial()) {self.error("") }
            boxeadorJugador.atacarEspecial()
        }
    }

    method iniciarPermisoEspecial(){
        game.onTick(4000, "permisoEspecial", {if(talvez.seaCierto(tipoNivel.probabilidadPermisoEspecial())) {self.darPermisoEspecial()}})
    }

    method darPermisoEspecial(){
        hayPermisoEspecial = true
        game.addVisual(imgAtaqueEspecial)
        gestorSonidos.sonidoAlertaEspecial()
        game.schedule(2000, {hayPermisoEspecial = false game.removeVisual(imgAtaqueEspecial)})
    }

    method jugadoPuedeAtacarEspecial() = hayPermisoEspecial && boxeadorJugador.estaQuieto()

    //IA del rival

    method iniciarIARival() {
        game.onTick(1000, "iaRival", {
            if (self.ambosConVida() && mario.sePuedePelear() && boxeadorRival.estaQuieto()) {
                self.decidirAccionDelRival()
            }
        })
    }


    method decidirAccionDelRival(){
        if(boxeadorRival.vida() <= 0) {boxeadorRival.estado(derrota) self.error("") } 
        accionesRival.findOrDefault({a => a.esEjecutable()}, accionDescansar).ejecutar(boxeadorRival)
    }

    // Método para verificar la vida de ambos boxeadores

    method ambosConVida() = boxeadorRival.vida() > 0 && boxeadorJugador.vida() > 0
    
    method verificarVida() {
        if (!self.ambosConVida()) {
            self.determinarGanador()
            gestorSonidos.sonidoCampana()
            game.removeTickEvent("permisoEspecial")
            game.onTick(500, "tribunaAlocada", {tribunaLoca.alocarse()})
            gestorSonidos.pararMusica()
            gestorSonidos.sonidoTribuna()

            game.schedule(4500,
               {self.reiniciarNivel()}
            )
        }
    }

    method determinarGanador() {
        if (boxeadorRival.vida() <= 0) {
            boxeadorJugador.estado(victoria)
            boxeadorRival.estado(derrota)
            boxeadorRival.position(game.at(6,5))
            pantallaFinal = pantallaVictoria
        } else if (boxeadorJugador.vida() <= 0) {
            boxeadorJugador.estado(derrota)
            boxeadorRival.estado(victoria)
            pantallaFinal = pantallaDerrota
        }
    }

    method reiniciarNivel(){
        if(gestorPantallas.pantallaActual() != self || !mario.sePuedePelear()) {self.error("") } 
        game.removeTickEvent("iaRival")
        game.removeTickEvent("tribunaAlocada")
        game.removeTickEvent("permisoEspecial")
        mario.reiniciar()
        self.limpiarVisuales()
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
    method imagenVersus() = imagenVersusJoe
    method accionesRival() = [new AccionAtacar(probabilidad=35), new AccionCubrirse(probabilidad=25)]
    method cambiarFondo() {pantallaRing.tipo(1)}
    method poderJugador() = 20
    method probabilidadPermisoEspecial() = 30
}

object nivel2 {
    method rival() = rocky
    method imagenVersus() = imagenVersusRocky
    method accionesRival() = [new AccionAtacar(probabilidad=45), new AccionCubrirse(probabilidad=25), new AccionAtacarEspecial(probabilidad=5)]
    method cambiarFondo() {pantallaRing.tipo(2)}
    method poderJugador() = 10
    method probabilidadPermisoEspecial() = 28
}

object nivel3 {
    method rival() = tyson
    method imagenVersus() = imagenVersusTyson
    method accionesRival() = [new AccionAtacar(probabilidad=80), new AccionCubrirse(probabilidad=5), new AccionAtacarEspecial(probabilidad=30)]
    method cambiarFondo() {pantallaRing.tipo(3)}
    method poderJugador() = 5
    method probabilidadPermisoEspecial() = 20
}

object talvez {
    method seaCierto(porcentaje) = (0.randomUpTo(1) * 100) < porcentaje
}

//Acciones del rival para la IA
class AccionRival {
    var probabilidad

    method ejecutar(boxeadorRival)

    method esEjecutable() = talvez.seaCierto(probabilidad)
}

class AccionAtacar inherits AccionRival {
    override method ejecutar(boxeadorRival) {
        boxeadorRival.prepararGolpe(1)
    }
}

class AccionAtacarEspecial inherits AccionRival {
    override method ejecutar(boxeadorRival) {
        boxeadorRival.prepararGolpe(2)
    }
}


class AccionCubrirse inherits AccionRival {
    override method ejecutar(boxeadorRival) {
        boxeadorRival.cubrirse()
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