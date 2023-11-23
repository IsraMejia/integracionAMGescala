

  //----------------------------------Sección Camara IR ----------------------------------------------

#include <CRC32.h>  // https://github.com/bakercp/CRC32
#include "Arduino.h"
#include <Wire.h>
#include "MLX90640_API.h"
#include "MLX90640_I2C_Driver.h"
#include <string.h>


#define EMMISIVITY 0.95
#define TA_SHIFT 8

struct RedBull {
  int total;
  int no_pack;
  double latitude;
  double longitude;
  int data[32];
  int id_mensaje;
};

paramsMLX90640 mlx90640;
const byte MLX90640_address = 0x33; //Default 7-bit unshifted address of the MLX90640
static float tempValues[32 * 24];
String dynamicArrayTemp[768];
int TemperaturasInt[768];
long NO_MENSAJE_ENVIADO=0;

String Trama_data;


void setup(void) {
  Serial.begin(115200);
  Serial2.begin(115200, SERIAL_8N1, 16, 17); // Utiliza los pines de hardware RX (16) y TX (17)
  //--------------------------Sección de Camara IR-------------------------
  Wire.begin();
  Wire.setClock(400000);
  Wire.beginTransmission((uint8_t)MLX90640_address);
  if (Wire.endTransmission() != 0) {
    Serial.println("MLX90640 not detected at default I2C address. Starting scan the device addr...");
    //Device_Scan();
  } else {
    Serial.println("MLX90640 online!");
  }
  int status;
  uint16_t eeMLX90640[832];
  status = MLX90640_DumpEE(MLX90640_address, eeMLX90640);
  if (status != 0) Serial.println("Failed to load system parameters");
  status = MLX90640_ExtractParameters(eeMLX90640, &mlx90640);
  if (status != 0) Serial.println("Parameter extraction failed");
  MLX90640_SetRefreshRate(MLX90640_address, 0x05);
  Wire.setClock(800000);
  NO_MENSAJE_ENVIADO=0;
}

void loop() {
  String* Temperaturas = readTempValues(); // 768 elementos
  RedBull farfi[24];
  int no_paquete = 1;
  int bufer_temp[12];
  int no_columnas = 32;
  int no_renglones = 24;
  int indice_array = 0;
  bool success_gps = false;
  float latitude=0;
  float longitude=0;

  //--------------------Sección GPS-------------------------------------------------------------------------------------------

 if (Serial2.available()) {
    char c = Serial2.read();

    if (c == '$') {
      Serial.println("Encontró el inicio de una trama");

      String sentence = Serial2.readStringUntil('\r');
      if (sentence.startsWith("GNGGA")) {
        Serial.println("La trama es del tipo GNGGA");
        int commaIndex = 0;
        for (int i = 0; i < sentence.length(); i++) {
          if (sentence[i] == ',') {
            commaIndex++;
            if (commaIndex == 2) {
              latitude = sentence.substring(i + 1, i + 10).toFloat();
              Serial.print("Latitud= ");
              Serial.print(latitude, 6);
            } else if (commaIndex == 4) {
              longitude = sentence.substring(i + 1, i + 11).toFloat();
              Serial.print(" Longitud= ");
              Serial.print(longitude, 6);
            } 
          }
        }
      }
    }
  }
//--------------------------------------------------------------------------------------

  //-------------Sección de array IMAGEN TERMICA---------------------------

  
  for (int renglon = 0; renglon < no_renglones; renglon++) {
    farfi[renglon].id_mensaje = NO_MENSAJE_ENVIADO;
    farfi[renglon].total = 24;
    farfi[renglon].no_pack = renglon;
    farfi[renglon].latitude = latitude;
    farfi[renglon].longitude = longitude;
    for (int columna = 0; columna < no_columnas; columna++) {
      farfi[renglon].data[columna] = Temperaturas[indice_array].toInt(); // Usar TemperaturasInt en lugar de Temperaturas
      indice_array += 1; // Faltaba un punto y coma aquí
    }
    String message = redBullToString(farfi[renglon]);
    for(int repeticion=0;repeticion<4;repeticion++){
      Serial.println(message);
      delayConMillis(20);
    }
    delayConMillis(1000);
  }

  delayConMillis(1000);
  NO_MENSAJE_ENVIADO+=1;
  if(NO_MENSAJE_ENVIADO>999){
    NO_MENSAJE_ENVIADO = 0; 
  }
}

String formatString(String s, int length) {
  while (s.length() < length) {
    s = "0" + s;
  }
  return s;
}

void delayConMillis(unsigned long milisegundos) {
  unsigned long tiempoInicio = millis();
  unsigned long duracionEspera = milisegundos;
  while (millis() - tiempoInicio < duracionEspera) {
    // Esperar hasta que se alcance la duración de espera
  }
}


String redBullToString(const RedBull& r) {
  CRC32 crc;
  
  String result = "";
  
  // Convertir y agregar total
  result += formatString(String(r.total), 2);

  // Convertir y agregar no_pack
  result += formatString(String(r.no_pack), 2);

  // Convertir y agregar latitude
  result += formatString(String(r.latitude, 7), 12);  // 4 enteros, punto, 7 decimales

  // Convertir y agregar longitude
  result += formatString(String(r.longitude, 7), 13);  // 5 enteros, punto, 7 decimales

  // Convertir y agregar data
  for (int i = 0; i < 32; i++) {
    result += formatString(String(r.data[i]), 3);  // 3 dígitos por entero
  }

  // Convertir y agregar id_mensaje
  result += formatString(String(r.id_mensaje), 3);

  // Calcular checksum CRC32
  for (unsigned int i = 0; i < result.length(); i++) {
    crc.update(result[i]);
  }
  uint32_t checksumValue = crc.finalize();

  // Convertir checksum a String y agregar al resultado
  result += formatString(String(checksumValue), 10);  // 10 dígitos para el checksum

  return result;
}


String* readTempValues() {
  for (byte x = 0 ; x < 2 ; x++) 
  {
    uint16_t mlx90640Frame[834];
    int status = MLX90640_GetFrameData(MLX90640_address, mlx90640Frame);
    if (status < 0)
    {
      Serial.print("GetFrame Error: ");
      Serial.println(status);
    }

    float vdd = MLX90640_GetVdd(mlx90640Frame, &mlx90640);
    float Ta = MLX90640_GetTa(mlx90640Frame, &mlx90640);

    float tr = Ta - TA_SHIFT; 

    MLX90640_CalculateTo(mlx90640Frame, &mlx90640, EMMISIVITY, tr, tempValues);
  }
  //Serial.println("\r\n===========================WaveShare MLX90640 Thermal Camera===============================");
  for (int i = 0; i < 768; i++) {
    if (((i % 32) == 0) && (i != 0)) {
      Serial.println(" ");
    }
     if (i==767){
       dynamicArrayTemp[i]=String((int)tempValues[i]);
  
    }else{
       dynamicArrayTemp[i]=String((int)tempValues[i]);
       dynamicArrayTemp[i]=String(dynamicArrayTemp[i]+",");
   
    }
    //Serial.print((int)tempValues[i]);
    //Serial.print(dynamicArrayTemp[i]);
    //Serial.print(",");
  }
  //Serial.println("\r\n===========================WaveShare MLX90640 Thermal Camera===============================");
  return dynamicArrayTemp;
}


void Device_Scan() {
  byte error, address;
  int nDevices;
  Serial.println("Scanning...");
  nDevices = 0;
  for (address = 1; address < 127; address++ )
  {
    Wire.beginTransmission(address);
    error = Wire.endTransmission();
    if (error == 0)
    {
      Serial.print("I2C device found at address 0x");
      if (address < 16)
        Serial.print("0");
      Serial.print(address, HEX);
      Serial.println("  !");
      nDevices++;
    }
    else if (error == 4)
    {
      Serial.print("Unknow error at address 0x");
      if (address < 16)
        Serial.print("0");
      Serial.println(address, HEX);
    }
  }
  if (nDevices == 0)
    Serial.println("No I2C devices found");
  else
    Serial.println("done");
}
