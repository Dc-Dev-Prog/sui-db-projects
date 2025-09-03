/*
/// Module: db_projects
module db_projects::db_projects;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

module db_projects::db_projects{

    use std::string::[String, utf8];
    use sui::vec_map::[VecMap, Self];

    key, store, drop, copy

    public struct Project has key, store {
        id:UID,
        nombre:String,
        repo: String,
        miembros: VecMap<u8, Miembros>
    }

    public  struct Miembros has store, drop {
        nombre: String,
        puesto: String,
        nivel: String,
        estado: String,
    } 
    
    #[error]
    const NOMBRE_REPETIDO: vector<u8> = b"Nombre ya existe";
    const PROJECT_NO_EXISTE: vector<u8> = b"Projecto no existe";

    public fun crear_project(nombre: Syring, repo: String, ctx: &mut TxContext){
        let projcet = Project { 
            id: object::new(ctx),
            nombre,
            repo,
            miembros: vec_map::empty()
        };

        transfer::transfer(project, tx_context::sender(ctx))
    }

    public fun agregar_mienbro(project: &mut Project, nombre: String, puesto: String, nivel: String){
        
        assert!(!project.miembros.contains(&nombre), NOMBRE_REPETIDO );

        let mienbros = Miembros {
            nombre,
            puesto,
            nivel,
            estado: utf8(b"activo")
        }

        project.mienbros.insert(key, mienbros)
    }

    public fun actualizar_mienbro(project: &mut Project, nombre: String, puesto: String, nivel: String){
        assert!(project.miembros.contains(&nombre), PROJECT_NO_EXISTE);

        let n_nombre = projcet.miembros.get_mut(&nombre).nombre;
        n_mobre = nombre;
        
        let n_puesto = projcet.miembros.get_mut(&nombre).puesto;
        n_puesto = puesto;

        let n_nombre = &mut projcet.miembros.get_mut(&nombre).nivel;
        n_nivel = nivel;
    }

    public fun borrar_mienbro(project: &mut Project, nombre: String){
        
        assert!(project.miembros.contains(&nombre), PROJECT_NO_EXISTE);
        
        project.miembros.remove();
    }
}