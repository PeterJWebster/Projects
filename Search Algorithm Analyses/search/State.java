package search;

import java.util.Set;

public interface State {
	Set<? extends Action> getApplicableActions();
	State getActionResult(Action action);

    @Override
    boolean equals(Object that); 
    @Override
    int hashCode();              
}
