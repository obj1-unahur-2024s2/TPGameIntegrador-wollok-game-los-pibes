import wollok.game.*
import Boxeadores.*
import pantallas.*

object juego{
	method iniciar(){
		game.title("Punch Out")
        game.cellSize(16)

		game.height(15)
		game.width(16)

        gestorPantallas.mostrarPantalla(pantallaCarga)
	}
}

object gestorPantallas {
    var property pantallaActual = null

    method mostrarPantalla(pantalla) {
        if (pantallaActual != null) {pantallaActual.ocultar() }
        pantallaActual = pantalla
        pantalla.mostrar()
    }
}