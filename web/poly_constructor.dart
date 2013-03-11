part of model_viewer;



void constructRect(vec3 minPoint, vec3 maxPoint, Float32Array vertexBuffer, Uint16Array indexBuffer, int vertArrOffset, int vertOffset, int indexOffset) {
  // Front face
  //TOPRIGHT
  vertexBuffer[vertArrOffset+ 0] = minPoint.x;
  vertexBuffer[vertArrOffset+ 1] = minPoint.y + maxPoint.y;
  vertexBuffer[vertArrOffset+ 2] = minPoint.z;
  vertexBuffer[vertArrOffset+ 3] = 0.0;
  vertexBuffer[vertArrOffset+ 4] = 1.0;

  //BOTTOMRIGHT
  vertexBuffer[vertArrOffset+ 5] = minPoint.x;
  vertexBuffer[vertArrOffset+ 6] = minPoint.y;
  vertexBuffer[vertArrOffset+ 7] = minPoint.z;
  vertexBuffer[vertArrOffset+ 8] = 1.0;
  vertexBuffer[vertArrOffset+ 9] = 1.0;

  //TOPLEFT
  vertexBuffer[vertArrOffset+10] = minPoint.x + maxPoint.x;
  vertexBuffer[vertArrOffset+11] = minPoint.y + maxPoint.y;
  vertexBuffer[vertArrOffset+12] = minPoint.z;
  vertexBuffer[vertArrOffset+13] = 0.0;
  vertexBuffer[vertArrOffset+14] = 0.0;

  //BOTTOMLEFT
  vertexBuffer[vertArrOffset+15] = minPoint.x + maxPoint.x;
  vertexBuffer[vertArrOffset+16] = minPoint.y;
  vertexBuffer[vertArrOffset+17] = minPoint.z;
  vertexBuffer[vertArrOffset+18] = 1.0;
  vertexBuffer[vertArrOffset+19] = 0.0;


  indexBuffer[indexOffset+ 0] = vertOffset + 0;
  indexBuffer[indexOffset+ 1] = vertOffset + 1;
  indexBuffer[indexOffset+ 2] = vertOffset + 2;
  indexBuffer[indexOffset+ 3] = vertOffset + 1;
  indexBuffer[indexOffset+ 4] = vertOffset + 3;
  indexBuffer[indexOffset+ 5] = vertOffset + 2;
  vertOffset += 4;

  // Back face

  vertexBuffer[vertArrOffset+20] = minPoint.x;
  vertexBuffer[vertArrOffset+21] = minPoint.y + maxPoint.y;
  vertexBuffer[vertArrOffset+22] = minPoint.z - maxPoint.z;
  vertexBuffer[vertArrOffset+23] = 1.0;
  vertexBuffer[vertArrOffset+24] = 1.0;

  vertexBuffer[vertArrOffset+25] = minPoint.x;
  vertexBuffer[vertArrOffset+26] = minPoint.y;
  vertexBuffer[vertArrOffset+27] = minPoint.z - maxPoint.z;
  vertexBuffer[vertArrOffset+28] = 0.0;
  vertexBuffer[vertArrOffset+29] = 1.0;

  vertexBuffer[vertArrOffset+30] = minPoint.x + maxPoint.x;
  vertexBuffer[vertArrOffset+31] = minPoint.y + maxPoint.y;
  vertexBuffer[vertArrOffset+32] = minPoint.z - maxPoint.z;
  vertexBuffer[vertArrOffset+33] = 1.0;
  vertexBuffer[vertArrOffset+34] = 0.0;

  vertexBuffer[vertArrOffset+35] = minPoint.x + maxPoint.x;
  vertexBuffer[vertArrOffset+36] = minPoint.y;
  vertexBuffer[vertArrOffset+37] = minPoint.z - maxPoint.z;
  vertexBuffer[vertArrOffset+38] = 0.0;
  vertexBuffer[vertArrOffset+39] = 0.0;


  indexBuffer[indexOffset+ 6] = vertOffset + 2;
  indexBuffer[indexOffset+ 7] = vertOffset + 1;
  indexBuffer[indexOffset+ 8] = vertOffset + 0;
  indexBuffer[indexOffset+ 9] = vertOffset + 2;
  indexBuffer[indexOffset+ 10] = vertOffset + 3;
  indexBuffer[indexOffset+ 11] = vertOffset + 1;
  vertOffset += 4;





  // Bottom Face

  vertexBuffer[vertArrOffset+40] = vertexBuffer[vertArrOffset+ 5];
  vertexBuffer[vertArrOffset+41] = vertexBuffer[vertArrOffset+ 6];
  vertexBuffer[vertArrOffset+42] = vertexBuffer[vertArrOffset+ 7];
  vertexBuffer[vertArrOffset+43] = 1.0;
  vertexBuffer[vertArrOffset+44] = 1.0;

  vertexBuffer[vertArrOffset+45] = vertexBuffer[vertArrOffset+25];
  vertexBuffer[vertArrOffset+46] = vertexBuffer[vertArrOffset+26];
  vertexBuffer[vertArrOffset+47] = vertexBuffer[vertArrOffset+27];
  vertexBuffer[vertArrOffset+48] = 0.0;
  vertexBuffer[vertArrOffset+49] = 1.0;

  vertexBuffer[vertArrOffset+50] = vertexBuffer[vertArrOffset+15];
  vertexBuffer[vertArrOffset+51] = vertexBuffer[vertArrOffset+16];
  vertexBuffer[vertArrOffset+52] = vertexBuffer[vertArrOffset+17];
  vertexBuffer[vertArrOffset+53] = 1.0;
  vertexBuffer[vertArrOffset+54] = 0.0;

  vertexBuffer[vertArrOffset+55] = vertexBuffer[vertArrOffset+35];
  vertexBuffer[vertArrOffset+56] = vertexBuffer[vertArrOffset+36];
  vertexBuffer[vertArrOffset+57] = vertexBuffer[vertArrOffset+37];
  vertexBuffer[vertArrOffset+58] = 0.0;
  vertexBuffer[vertArrOffset+59] = 0.0;

  indexBuffer[indexOffset+ 12] = vertOffset + 3;
  indexBuffer[indexOffset+ 13] = vertOffset + 2;
  indexBuffer[indexOffset+ 14] = vertOffset + 1;
  indexBuffer[indexOffset+ 15] = vertOffset + 0;
  indexBuffer[indexOffset+ 16] = vertOffset + 1;
  indexBuffer[indexOffset+ 17] = vertOffset + 2;
  vertOffset += 4;

  // Top Face

  vertexBuffer[vertArrOffset+60] = vertexBuffer[vertArrOffset+ 0];
  vertexBuffer[vertArrOffset+61] = vertexBuffer[vertArrOffset+ 1];
  vertexBuffer[vertArrOffset+62] = vertexBuffer[vertArrOffset+ 2];
  vertexBuffer[vertArrOffset+63] = 0.0;
  vertexBuffer[vertArrOffset+64] = 1.0;

  vertexBuffer[vertArrOffset+65] = vertexBuffer[vertArrOffset+20];
  vertexBuffer[vertArrOffset+66] = vertexBuffer[vertArrOffset+21];
  vertexBuffer[vertArrOffset+67] = vertexBuffer[vertArrOffset+22];
  vertexBuffer[vertArrOffset+68] = 1.0;
  vertexBuffer[vertArrOffset+69] = 1.0;

  vertexBuffer[vertArrOffset+70] = vertexBuffer[vertArrOffset+10];
  vertexBuffer[vertArrOffset+71] = vertexBuffer[vertArrOffset+11];
  vertexBuffer[vertArrOffset+72] = vertexBuffer[vertArrOffset+12];
  vertexBuffer[vertArrOffset+73] = 0.0;
  vertexBuffer[vertArrOffset+74] = 0.0;

  vertexBuffer[vertArrOffset+75] = vertexBuffer[vertArrOffset+30];
  vertexBuffer[vertArrOffset+76] = vertexBuffer[vertArrOffset+31];
  vertexBuffer[vertArrOffset+77] = vertexBuffer[vertArrOffset+32];
  vertexBuffer[vertArrOffset+78] = 1.0;
  vertexBuffer[vertArrOffset+79] = 0.0;

  indexBuffer[indexOffset+ 18] = vertOffset + 2;
  indexBuffer[indexOffset+ 19] = vertOffset + 1;
  indexBuffer[indexOffset+ 20] = vertOffset + 0;
  indexBuffer[indexOffset+ 21] = vertOffset + 2;
  indexBuffer[indexOffset+ 22] = vertOffset + 3;
  indexBuffer[indexOffset+ 23] = vertOffset + 1;
  vertOffset += 4;





  //Left

  vertexBuffer[vertArrOffset+80] = vertexBuffer[vertArrOffset+ 20];
  vertexBuffer[vertArrOffset+81] = vertexBuffer[vertArrOffset+ 21];
  vertexBuffer[vertArrOffset+82] = vertexBuffer[vertArrOffset+ 22];
  vertexBuffer[vertArrOffset+83] = 1.0;
  vertexBuffer[vertArrOffset+84] = 0.0;

  vertexBuffer[vertArrOffset+85] = vertexBuffer[vertArrOffset+25];
  vertexBuffer[vertArrOffset+86] = vertexBuffer[vertArrOffset+26];
  vertexBuffer[vertArrOffset+87] = vertexBuffer[vertArrOffset+27];
  vertexBuffer[vertArrOffset+88] = 1.0;
  vertexBuffer[vertArrOffset+89] = 1.0;

  vertexBuffer[vertArrOffset+90] = vertexBuffer[vertArrOffset+0];
  vertexBuffer[vertArrOffset+91] = vertexBuffer[vertArrOffset+1];
  vertexBuffer[vertArrOffset+92] = vertexBuffer[vertArrOffset+2];
  vertexBuffer[vertArrOffset+93] = 0.0;
  vertexBuffer[vertArrOffset+94] = 0.0;

  vertexBuffer[vertArrOffset+95] = vertexBuffer[vertArrOffset+5];
  vertexBuffer[vertArrOffset+96] = vertexBuffer[vertArrOffset+6];
  vertexBuffer[vertArrOffset+97] = vertexBuffer[vertArrOffset+7];
  vertexBuffer[vertArrOffset+98] = 0.0;
  vertexBuffer[vertArrOffset+99] = 1.0;

  indexBuffer[indexOffset+ 24] = vertOffset + 1;
  indexBuffer[indexOffset+ 25] = vertOffset + 3;
  indexBuffer[indexOffset+ 26] = vertOffset + 2;
  indexBuffer[indexOffset+ 27] = vertOffset + 0;
  indexBuffer[indexOffset+ 28] = vertOffset + 1;
  indexBuffer[indexOffset+ 29] = vertOffset + 2;

  vertOffset += 4;

  //Right
  vertexBuffer[vertArrOffset+100] = vertexBuffer[vertArrOffset+ 30];
  vertexBuffer[vertArrOffset+101] = vertexBuffer[vertArrOffset+ 31];
  vertexBuffer[vertArrOffset+102] = vertexBuffer[vertArrOffset+ 32];
  vertexBuffer[vertArrOffset+103] = 1.0;
  vertexBuffer[vertArrOffset+104] = 1.0;

  vertexBuffer[vertArrOffset+105] = vertexBuffer[vertArrOffset+35];
  vertexBuffer[vertArrOffset+106] = vertexBuffer[vertArrOffset+36];
  vertexBuffer[vertArrOffset+107] = vertexBuffer[vertArrOffset+37];
  vertexBuffer[vertArrOffset+108] = 1.0;
  vertexBuffer[vertArrOffset+109] = 0.0;

  vertexBuffer[vertArrOffset+110] = vertexBuffer[vertArrOffset+10];
  vertexBuffer[vertArrOffset+111] = vertexBuffer[vertArrOffset+11];
  vertexBuffer[vertArrOffset+112] = vertexBuffer[vertArrOffset+12];
  vertexBuffer[vertArrOffset+113] = 0.0;
  vertexBuffer[vertArrOffset+114] = 1.0;

  vertexBuffer[vertArrOffset+115] = vertexBuffer[vertArrOffset+15];
  vertexBuffer[vertArrOffset+116] = vertexBuffer[vertArrOffset+16];
  vertexBuffer[vertArrOffset+117] = vertexBuffer[vertArrOffset+17];
  vertexBuffer[vertArrOffset+118] = 0.0;
  vertexBuffer[vertArrOffset+119] = 0.0;

  indexBuffer[indexOffset+ 30] = vertOffset + 2;
  indexBuffer[indexOffset+ 31] = vertOffset + 1;
  indexBuffer[indexOffset+ 32] = vertOffset + 0;
  indexBuffer[indexOffset+ 33] = vertOffset + 2;
  indexBuffer[indexOffset+ 34] = vertOffset + 3;
  indexBuffer[indexOffset+ 35] = vertOffset + 1;
}





