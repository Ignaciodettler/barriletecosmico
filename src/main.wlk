class Localidades {
	var nombre
	var equipajeImprescindible = []
	var precio
	var kilometro
	
	constructor(unNombre,objetosDeEquipaje,unPrecio,unKilometro){
		nombre=unNombre
		equipajeImprescindible= objetosDeEquipaje
		precio = unPrecio
		kilometro = unKilometro
	}
	
	
	method esDestinoDestacado() {
        return precio > 2000
    }

    method aplicarDescuento(descuento) {
        precio -= precio / 100 * descuento
        equipajeImprescindible.add("Certificado de Descuento")
    }

    method esDestinoPeligroso() {
        return equipajeImprescindible.any({equipaje => equipaje.contains("Vacuna")})
    }

    method nombre() {
        return nombre
    }
    
    method precio() {
    	return precio
    }
    method kilometro(){
    	return kilometro
    }
    
    method tieneCertificadoDeDescuento() {
    	return equipajeImprescindible.contains("Certificado de Descuento")
    }
    method calcularKilometroEntre(localidad){
    	return (self.kilometro() - localidad.kilometro()).abs()
    }
}


object barrileteCosmico {
    var localidades = #{marDeAjo, marDelPlata, lasToninas, buenosAires}
    var usuarios = []
    var medioDeTransporte =#{}

    method obtenerLosDestinosMasImportantes() {
        return localidades.filter({destino => destino.esDestinoDestacado()})
    }

    method aplicarDescuentoALosDestinos(descuento) {
        localidades.forEach({destino => destino.aplicarDescuento(descuento)})
    }

    method esEmpresaExtrema() {
        return localidades.any({destino => destino.esDestinoPeligroso()})
    }

    method conocerCartaDeDestinos() {
        return localidades.map({destino => destino.nombre()})
    }

    method destinos() {
        return localidades
    }
    method armarViaje(unUsuario,unaLocalidad){
    	var UnViaje = new Viajes(unaLocalidad,unUsuario.localidadDeOrigen(),medioDeTransporte.anyOne())
    }
}

class Usuarios {
    var usuario 
    var viajes = #{}
    var dineroEnCuenta 
    var usuariosSeguidos = []
    var localidadDeOrigen
    
    constructor(unUsuario,unosViajes, dinero,unosUsuariosSeguidos,unaLocalidadDeOrigen){
    	usuario= unUsuario
    	viajes = unosViajes
    	dineroEnCuenta=dinero
    	usuariosSeguidos=unosUsuariosSeguidos
    	localidadDeOrigen=unaLocalidadDeOrigen 
    }

    method viajarA(localidad) {
        if(dineroEnCuenta >= localidad.precio()) {
            dineroEnCuenta -= localidad.precio()
            viajes.add(localidad)
            localidadDeOrigen=localidad
        }
        else{
        	throw new NoPuedoViajarException(message = " No puedo viajar, soy pobre")
        }
    }

    method obtenerKilometrosDisponibles() {
        return viajes.sum({localidad => localidad.calcularKilometroEntre()})
    }

    method seguirUsuario(otroUsuario) {
    	usuariosSeguidos.add(otroUsuario)
        otroUsuario.devolverSeguida(self)
    }

    method devolverSeguida(otroUsuario) {
        usuariosSeguidos.add(otroUsuario)
    }
    
    method conoce(localidad) {
    	return viajes.contains(localidad)
    }
    
    method dineroEnCuenta() {
    	return dineroEnCuenta
    }
    method localidadDeOrigen(){
    	return localidadDeOrigen
    }
}
class NoPuedoViajarException inherits Exception{}

class MediosDeTransporte{
	var tiempo
	var precioPorKilometro
	
	constructor(unTiempo,unPrecio){
		tiempo=unTiempo
		precioPorKilometro= unPrecio
	}
	
	method precioPorKilometro(){
		return precioPorKilometro
	}
	method tiempo(){
		return tiempo
	}
}

class Viajes{
	var localidad
	var origen
	var medioDeTransporte
	
	
	constructor(unaLocalidad,unOrigen,unTransporte){
		localidad= unaLocalidad
		origen= unOrigen
		medioDeTransporte=unTransporte
	}
	
	
	method localidad(){
		return localidad
	}
	method origen(){
		return origen
	}
	method precio(){
		return	(medioDeTransporte.pesosPorKilometro()*origen.calcularKilometroEntre(localidad)+localidad.precio())
	}
}