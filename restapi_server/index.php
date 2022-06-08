<?php
require_once "model/mahasiswa.php";
$mhs = new Mahasiswa();
$request_method=$_SERVER["REQUEST_METHOD"];
switch ($request_method) {
    case 'GET':
        if(!empty($_GET["id"]))
        {
            $id=intval($_GET["id"]);
            $mhs->GetMahasiswa($id);
        }
        else
        {
            $mhs->GetMahasiswas();
        }
        break;
    case 'POST':
        if(!empty($_GET["id"]))
        {
            $id=intval($_GET["id"]);
            $mhs->UpdateMahasiswa($id);
        }
        else
        {
            $mhs->CreateMahasiswa();
        }     
        break; 

    // case 'POST':
    //     $mhs->CreateMahasiswa();    
    //     break; 

    // case 'PATCH':
    //     if(!empty($_GET["id"]))
    //     {
    //         $id=intval($_GET["id"]);
    //         $mhs->UpdateMahasiswa($id);
    //     }  
    //     break;
    
    case 'DELETE':
        $id=intval($_GET["id"]);
        $mhs->DeleteMahasiswa($id);
        break;
    default:
        // Invalid Request Method
        header("HTTP/1.0 405 Method Not Allowed");
        break;
    break;
}

?>