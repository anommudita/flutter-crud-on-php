<?php
require_once "koneksi/koneksi.php";
class Mahasiswa
{
   public  function GetMahasiswas()
   {
      global $mysqli;
      $data = array();

      $query = "SELECT * FROM mahasiswa";
      $result = $mysqli->query($query);

      while ($row = mysqli_fetch_object($result)) {
         $data[] = $row;
      }
      $response = array(
         'status' => 1,
         'message' => 'Success',
         'data' => $data
      );
      header('Content-Type: application/json');
      header("Access-Control-Allow-Origin: *");
      header("Access-Control-Allow-Headers: Access-Control-Allow-Origin, Accept");
      echo json_encode($response);
   }

   public function GetMahasiswa($id = 0)
   {
      global $mysqli;
      $query = "SELECT * FROM mahasiswa";
      if ($id != 0) {
         $query .= " WHERE id=" . $id . " LIMIT 1";
      }
      $data = array();
      $result = $mysqli->query($query);
      if ($row = mysqli_fetch_object($result)) {
         $data[] = $row;
      }
      $response = array(
         'status' => 1,
         'message' => 'Success',
         'data' => $data
      );
      header('Content-Type: application/json');
      header("Access-Control-Allow-Origin: *");
      header("Access-Control-Allow-Headers: Access-Control-Allow-Origin, Accept");
      echo json_encode($response);
   }

   public function CreateMahasiswa()
   {
      global $mysqli;
      $arrcheckpost = array('nim' => '', 'nama' => '', 'jk' => '', 'alamat' => '', 'jurusan'   => '');
      $hitung = count(array_intersect_key($_POST, $arrcheckpost));
      if ($hitung == count($arrcheckpost)) {
         $result = mysqli_query($mysqli, "INSERT INTO mahasiswa SET
               nim = '$_POST[nim]',
               nama = '$_POST[nama]',
               jk = '$_POST[jk]',
               alamat = '$_POST[alamat]',
               jurusan = '$_POST[jurusan]'");
         if ($result) {
            $response = array(
               'status' => 1,
               'message' => 'Mahasiswa Added Successfully.'
            );
         } else {
            $response = array(
               'status' => 0,
               'message' => 'Add Mahasiswa Failed.'
            );
         }
      } else {
         $response = array(
            'status' => 0,
            'message' => 'Parameter Do Not Match'
         );
      }

      header('Content-Type: application/json');
      header("Access-Control-Allow-Origin: *");
      header("Access-Control-Allow-Headers: Access-Control-Allow-Origin, Accept");
      echo json_encode($response);
   }

   function UpdateMahasiswa($id)
   {
      global $mysqli;
      $arrcheckpost = array('nim' => '', 'nama' => '', 'jk' => '', 'alamat' => '', 'jurusan'   => '');
      $hitung = count(array_intersect_key($_POST, $arrcheckpost));
      if ($hitung == count($arrcheckpost)) {
         $result = mysqli_query($mysqli, "UPDATE mahasiswa SET
                        nim      = '$_POST[nim]',
                        nama     = '$_POST[nama]',
                        jk       = '$_POST[jk]',
                        alamat   = '$_POST[alamat]',
                        jurusan  = '$_POST[jurusan]'
                        WHERE id = '$id'");

         if ($result) {
            $response = array(
               'status' => 1,
               'message' => 'Mahasiswa Updated Successfully.'
            );
         } else {
            $response = array(
               'status' => 0,
               'message' => 'Update Mahasiswa Failed.'
            );
         }
      } else {
         $response = array(
            'status' => 0,
            'message' => 'Parameter Do Not Match',
            'hitung' => $hitung,
            // 'count'=>$_PATCH['nim']
         );
      }
      header('Content-Type: application/json');
      echo json_encode($response);
   }

   function DeleteMahasiswa($id)
   {
      global $mysqli;
      $query = "DELETE FROM mahasiswa WHERE id=" . $id;
      if (mysqli_query($mysqli, $query)) {
         $response = array(
            'status' => 1,
            'message' => 'Mahasiswa Deleted Successfully.'
         );
      } else {
         $response = array(
            'status' => 0,
            'message' => 'Delete Mahasiswa Failed.'
         );
      }

      header('Content-Type: application/json');
      header("Access-Control-Allow-Origin: *");
      header("Access-Control-Allow-Headers: Access-Control-Allow-Origin, Accept");
      echo json_encode($response);
   }
}