import Boxeadores.*
import pantallas.*
import juego.*

//SONIDO

object gestorSonidos {
    // Referencias a música y efectos actuales
    var musicaActual = null

    // Diccionarios para almacenar música y efectos
    const musicas = new Dictionary()
    const efectos = new Dictionary()

    // Inicializar sonidos
    method initialize() {
        // Música
        musicas.put("menu", game.sound("mscMenu.ogg"))
        musicas.put("dificultad", game.sound("mscDificultad.ogg"))
        musicas.put("pelea", game.sound("mscPelea.ogg"))
        musicas.put("victoria", game.sound("mscVictoria.ogg"))
        musicas.put("derrota", game.sound("mscDerrota.ogg"))
        musicas.put("comienza", game.sound("mscComienza.ogg"))

        // Efectos de sonido
        efectos.put("golpe", "sonGolpe.ogg")
        efectos.put("golpeEspecial", "sonGolpeEspecial.ogg")
        efectos.put("bloqueo", "sonBloqueo.ogg")
        efectos.put("bloqueoEspecial", "sonBloqueoEspecial.ogg")
        efectos.put("enter", "sonEnter.ogg")
        efectos.put("campana", "sonCampana.ogg")
        efectos.put("campanaSimple", "sonCampanaSimple.ogg")
        efectos.put("tribuna", "sonTribuna.ogg")
        efectos.put("alertaEspecial", "sonAlertaEspecial.ogg")
    }

    // Método para reproducir música
    method reproducirMusica(nombre) {
        if(musicas.get(nombre) == musicaActual) {self.error("ya se está reproduciendo")}

        self.pararMusica()
        musicaActual = musicas.get(nombre)
        musicaActual.shouldLoop(true)
        musicaActual.volume(1.0)
        musicaActual.play()
    }

    // Método para detener la música
    method pararMusica() {
        if (musicaActual != null) {
            musicaActual.stop()
        }
        musicaActual = null
    }

    // Método para reproducir efectos de sonido
    method reproducirEfecto(nombre) {
        const ruta = efectos.get(nombre)
        if (ruta == null) { self.error("Efecto de sonido no encontrado: " + nombre) }

        const efecto = game.sound(ruta)
        efecto.volume(0.8)
        efecto.play()
    }

    method musicaMenu() {self.reproducirMusica("menu")}
    method musicaDificultad() {self.reproducirMusica("dificultad")}
    method musicaComienzaNivel() {self.reproducirMusica("comienza")}
    method musicaPelea() {self.reproducirMusica("pelea")}
    method musicaVictoria() {self.reproducirMusica("victoria")}
    method musicaDerrota() {self.reproducirMusica("derrota")}


    method sonidoGolpe() {self.reproducirEfecto("golpe")}
    method sonidoGolpeEspecial() {self.reproducirEfecto("golpeEspecial")}
    method sonidoBloqueo() {self.reproducirEfecto("bloqueo")}
    method sonidoBloqueoEspecial() {self.reproducirEfecto("bloqueoEspecial")}
    method sonidoEnter() {self.reproducirEfecto("enter")}
    method sonidoCampana() {self.reproducirEfecto("campana")}
    method sonidoCampanaSimple() {self.reproducirEfecto("campanaSimple")}
    method sonidoTribuna() {self.reproducirEfecto("tribuna")}
    method sonidoAlertaEspecial() {self.reproducirEfecto("alertaEspecial")}
}

//IMAGEN

class Imagen {
    var property tipo = ""
    var property position = game.at(0, 0)
    method image() = "imagen" + self.tipo() + ".png" 
}

object imagenCarga inherits Imagen{ 
    method initialize() {tipo = "PantallaCarga"}
}
object imagenMenu inherits Imagen{ 
    method initialize() {tipo = "Menu"}
}

object imagenDificultad inherits Imagen{
	method initialize() {tipo = "MenuDificultad"}
}

object imagenVersusJoe inherits Imagen{
	method initialize() {tipo = "PantallaVersusJoe"}
}
object imagenVersusRocky inherits Imagen{
	method initialize() {tipo = "PantallaVersusRocky"}
}
object imagenVersusTyson inherits Imagen{
	method initialize() {tipo = "PantallaVersusTyson"}
}

object pantallaRing inherits Imagen{
    override method image() = "ring" + self.tipo() + ".png"
}

object tribunaLoca inherits Imagen{
    var alocada = false
    method initialize() {tipo = "TribunaLoca"}
    
    method alocarse() {
        if(alocada || gestorPantallas.pantallaActual() != pantallaNivel) 
        {game.removeVisual(self) alocada = false}
        else {game.addVisual(self) alocada = true}
    }
}

object imagenDerrota inherits Imagen{
	method initialize() {tipo = "PantallaDerrota"}
}

object imagenVictoria inherits Imagen{
    method initialize() {tipo = "PantallaVictoria"}
}

object imgAtaqueEspecial{
    method position() = game.at(3, 3)
    method image() = "imgAtaqueEspecial.png"
}

//Imágenes Mario

object mario{
    var contador = 1
    var sePuedePelear = false

    method contador() = contador
    method sePuedePelear() = sePuedePelear
    method position() = game.at(13, 1)
    method image() = "mario1.png"

    method contar(){
        game.addVisual(globoDialogo)
         self.sonarCampanadas()

        game.onTick(1000, "contando", {
                if(contador < 4){
                    contador += 1
                    self.sonarCampanadas()
                }
                else{
                    contador = 4 
                    sePuedePelear = true 
                    game.removeTickEvent("contando")
                    game.removeVisual(globoDialogo)
                    game.removeVisual(self)
                }
            })
    }

    method sonarCampanadas() {if(contador <= 3) {gestorSonidos.sonidoCampanaSimple()} 
        else if(contador == 4) {gestorSonidos.sonidoCampana()}}
    method reiniciar(){
        contador = 1
        sePuedePelear = false
    }
}

object globoDialogo{
    method position() = game.at(10, 3)
    method image() = "globo" + mario.contador() + ".png"
}