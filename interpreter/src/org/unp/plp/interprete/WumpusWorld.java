package org.unp.plp.interprete;

import java.util.ArrayList;

public class WumpusWorld {

  private int filas;
  private int columnas;
  private Celda[][] celdas;

  public static WumpusWorld crear(int filas, int columnas) {
    System.out.println("Esto esta dentro de WumpusWorld " + filas + " " + columnas);

    return new WumpusWorld(filas, columnas);
  }

  public WumpusWorld(int filas, int columnas) {
    this.filas = filas;
    this.columnas = columnas;

    for (int i = 0; i < filas; i++)
      for (int j = 0; j < columnas; j++)
        celdas[i][j] = new Celda(i, j);
  }

  void agregarElemento(ELEMENTO elem, Celda celda) {
    celda.setElemento(elem);
  }
  
  void removerElemento(ELEMENTO elem, Celda celda) {
    celda.setElemento(null);
  }

  public Celda getCelda(int fil, int col) {
    return celdas[fil][col];
  }
  
  void print() {
    System.out.println("El mundillo");
  }
}

enum ELEMENTO { 
  PIT, 
  GOLD, 
  WUMPUS, 
  HERO 
}

class Celda {

  private int i;
  private int j;
  private ELEMENTO elemento;

  public Celda(int i, int j) {
    this.i = i;
    this.j = j;
  }

  public int getI() {
    return i;
  }

  public int getJ() {
    return j;
  }

  public Elemento getElemento() {
    return elemento;
  }

  public void setElemento(ELEMENTO elemento) {
    this.elemento = elemento;
  }
}
