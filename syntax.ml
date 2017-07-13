(* ML interpreter / type reconstruction *)
type id = string

type tyvar = int

type binOp = | Equal | Plus | Minus | Mult | Lt | And | Or | Cons

type ty = TyInt | TyBool | TyVar of tyvar | TyFun of ty * ty



let pp_ty = function  TyInt -> print_string "int"
                    | TyBool -> print_string "bool"
                    | TyVar x -> print_string (string_of_int x)
                    | TyFun (x, y) -> print_string "tyfun"

let fresh_tyvar = let counter = ref 0 in 
                    let body () = 
                        let v = !counter in
                            counter := v + 1 ; v in body
let rec freevar_ty = function
                          TyVar x -> MySet.singleton x
                        | TyFun (x, y) -> let tyx = freevar_ty x in
                                            let tyy = freevar_ty y in
                                                MySet.union tyx tyy
                        | _ -> MySet.empty

type exp =
    Var of id
  | ILit of int 
  | BLit of bool
  | BinOp of binOp * exp * exp
  | IfExp of exp * exp * exp
  | LetExp of id * exp * exp
  | FunExp of id * exp 
  | AppExp of exp * exp 
  | LetRecExp of id * id * exp * exp (*追加*)

type program =
    Exp of exp
    | Decl of id * exp
    | RecDecl of id * id * exp (*追加*)
    | DeclDecl of id * exp * program (*追加 Ex3.3.2*)
    | Nothing 