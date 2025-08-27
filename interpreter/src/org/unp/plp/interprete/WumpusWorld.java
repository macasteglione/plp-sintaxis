package org.unp.plp.interprete;

import java.util.TreeMap;

public class WumpusWorld {

    private final int filas;
    private final int columnas;
    private final Celda[][] celdas;
    private final TreeMap<String, ELEMENTO> elementos;

    private boolean isInsideMatrix(int _fila, int _columna) {
        if ((_fila < filas && _fila > 0) && (_columna > 0 && _columna < columnas)) {
            return true;
        }

        System.out.println("Coordenada fuera de rango: (" + _fila + ", " + _columna + ")");
        return false;
    }

    public static WumpusWorld crear(int filas, int columnas) {
        System.out.println("Esto esta dentro de WumpusWorld " + filas + "x" + columnas);

        return new WumpusWorld(filas, columnas);
    }

    public WumpusWorld(int filas, int columnas) {
        this.filas = filas;
        this.columnas = columnas;
        this.celdas = new Celda[filas][columnas];
        this.elementos = new TreeMap<>();

        for (int i = 0; i < filas; i++) {
            for (int j = 0; j < columnas; j++) {
                celdas[i][j] = new Celda(i, j);
            }
        }
    }

    public void agregarElemento(ELEMENTO elem, Celda celda) {
        if (celda == null) {
            return;
        }

        if (elem == ELEMENTO.HERO && elementos.containsValue(elem)) {
            System.out.println("Ya existe un heroe en el mundo");
            return;
        }

        celda.setElemento(elem);
        elementos.put(celda.getCoordenadas(), elem);
    }

    public void agregarElemento(ELEMENTO elem, ConditionList condiciones) {
        int elementosAgregados = 0;

        for (int i = 0; i < filas; i++) {
            for (int j = 0; j < columnas; j++) {
                if (condiciones.evaluateAll(i, j)) {
                    Celda celda = getCelda(i, j);
                    if (celda != null) {
                        // Para el héroe, solo permitir uno
                        if (elem == ELEMENTO.HERO && elementos.containsValue(elem)) {
                            System.out.println("Ya existe un héroe en el mundo, saltando posición (" + i + ", " + j + ")");
                            continue;
                        }

                        celda.setElemento(elem);
                        elementos.put(celda.getCoordenadas(), elem);
                        elementosAgregados++;
                        System.out.println("Agregado " + elem + " en (" + i + ", " + j + ")");
                    }
                }
            }
        }
    }

    public void removerElemento(ELEMENTO elem, Celda celda) {
        if (celda == null) {
            return;
        }

        celda.setElemento(null);
        elementos.remove(celda.getCoordenadas(), elem);
    }

    public Celda getCelda(int fil, int col) {
        if (!isInsideMatrix(fil, col)) {
            return null;
        }

        return celdas[fil][col];
    }

    public void print() {
        elementos.forEach((coordenada, elemento) -> {
            System.out.println("Elemento: " + elemento + " en coordenada: " + coordenada);
        });
    }
}

enum ELEMENTO {
    PIT,
    GOLD,
    WUMPUS,
    HERO
}

class Celda {

    private final int i;
    private final int j;
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

    public ELEMENTO getElemento() {
        return elemento;
    }

    public void setElemento(ELEMENTO elemento) {
        this.elemento = elemento;
    }

    public String getCoordenadas() {
        return "(" + i + ", " + j + ")";
    }
}
