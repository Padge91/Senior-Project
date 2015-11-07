package common;

/**
 * Created by Tyler on 11/6/2015.
 */
public class Movie extends Item {

    private int runtime;

    public Movie() {
        super();
    }

    public Movie(int runtime) {
        super();
        this.runtime = runtime;
    }

    public int getRuntime() {
        return runtime;
    }

    public void setRuntime(int runtime) {
        this.runtime = runtime;
    }
}
