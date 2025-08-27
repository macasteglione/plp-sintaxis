package org.unp.plp.interprete;

import java.util.ArrayList;
import java.util.List;

class ConditionList {

    private final List<Condition> conditions = new ArrayList<>();

    public void addCondition(Condition condition) {
        conditions.add(condition);
    }

    public boolean evaluateAll(int i, int j) {
        for (Condition cond : conditions) {
            if (!cond.evaluate(i, j)) {
                return false;
            }
        }
        return true;
    }

    public List<Condition> getConditions() {
        return conditions;
    }
}
