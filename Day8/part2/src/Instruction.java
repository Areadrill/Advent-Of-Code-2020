public enum Instruction {
    ACC {
        @Override
        Pair<Integer, Integer> handle(int arg, int accumulator, int ip) {
            return new Pair(accumulator += arg, ip);
        }
    },
    JMP {
        @Override
        Pair<Integer, Integer> handle(int arg, int accumulator, int ip) {
            return new Pair(accumulator, ip + arg-1);
        }
    },
    NOP {
        @Override
        Pair<Integer, Integer> handle(int arg, int accumulator, int ip) {
            return new Pair(accumulator, ip);
        }
    };

    abstract Pair<Integer, Integer> handle(int arg, int accumulator, int ip);
}


