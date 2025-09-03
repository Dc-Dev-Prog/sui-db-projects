module db_projects::db_projects {

    use std::string::{String, utf8};
    use sui::vec_map::{VecMap, Self};

    public struct Proyecto has key, store {
        id:UID,
        nombre:String,
        repo: String,
        miembros: VecMap<String, Miembros>
    }

    public  struct Miembros has store, drop {
        nombre: String,
        puesto: String,
        nivel: String,
        estado: String,
    } 
    
    #[error]
    const NOMBRE_REPETIDO: vector<u8> = b"Nombre ya existe";
    
    #[error]
    const PROYECTO_NO_EXISTE: vector<u8> = b"Projecto no existe";


    public fun crear_proyecto(nombre: String, repo: String, ctx: &mut TxContext){
        let proyecto = Proyecto { 
            id: object::new(ctx),
            nombre,
            repo,
            miembros: vec_map::empty()
        };

        transfer::transfer(proyecto, tx_context::sender(ctx))
    }

    public fun agregar_mienbro(proyecto: &mut Proyecto, nombre: String, puesto: String, nivel: String){
        
        assert!(!proyecto.miembros.contains(&nombre), NOMBRE_REPETIDO );

        let miembros = Miembros {
            nombre,
            puesto,
            nivel,
            estado: utf8(b"activo")
        };

        proyecto.miembros.insert(nombre, miembros);
    }

    public fun actualizar_mienbro(proyecto: &mut Proyecto, nombre: String, puesto: String, nivel: String){
        
        assert!(proyecto.miembros.contains(&nombre), PROYECTO_NO_EXISTE );

        let mut n_nombre = proyecto.miembros.get_mut(&nombre).nombre;
        n_nombre = nombre;
        
        let mut n_puesto = proyecto.miembros.get_mut(&nombre).puesto;
        n_puesto = puesto;

        let mut n_nivel = proyecto.miembros.get_mut(&nombre).nivel;
        n_nivel = nivel;
    }

    public fun borrar_mienbro(proyecto: &mut Proyecto, nombre: String){
        
        assert!(proyecto.miembros.contains(&nombre), PROYECTO_NO_EXISTE );
        
        proyecto.miembros.remove(&nombre);
    }
}