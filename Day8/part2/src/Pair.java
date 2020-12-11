class Pair<T,S> {
    private T val1;
    private S val2;

    public Pair(T val1, S val2) {
        this.val1 = val1;
        this.val2 = val2;
    }

    public T getFirst() {
        return val1;
    }

    public S getSecond() {
        return val2;
    }
}