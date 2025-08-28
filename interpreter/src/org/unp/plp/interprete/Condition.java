package org.unp.plp.interprete;

public class Condition {

    public char variable;  // 'i' o 'j'
    public String operator;  // "=", "<", "<=", ">", ">=", "!="
    public int value;

    public Condition(char variable, String operator, int value) {
        this.variable = variable;
        this.operator = operator;
        this.value = value;
    }

    public boolean evaluate(int i, int j) {
        int varValue = (variable == 'i') ? i : j;

        return switch (operator) {
            case "=" ->
                varValue == value;
            case "<" ->
                varValue < value;
            case "<=" ->
                varValue <= value;
            case ">" ->
                varValue > value;
            case ">=" ->
                varValue >= value;
            case "!=" ->
                varValue != value;
            default ->
                false;
        };
    }
}
