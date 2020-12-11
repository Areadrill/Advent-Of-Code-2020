import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

public class Computer {
    private int instructionPointer;
    private int accumulator;

    private List<Pair<Instruction, Integer>> instructions;
    private List<Integer> instructionOccurences;

    public int getInstructionPointer() {
        return instructionPointer;
    }

    public int getAccumulator() {
        return accumulator;
    }

    public final List<Pair<Instruction, Integer>> getInstructions() {
        return instructions;
    }

    public final List<Integer> getInstructionOccurences() {
        return instructionOccurences;
    }

    public Computer(List<String> instructions) {
        instructionPointer = 0;
        accumulator = 0;

        this.instructions = instructions.stream()
                .map(val -> {
                    final String[] instructionTokens = val.split(" ");
                    final Instruction instruction;
                    switch (instructionTokens[0]) {
                        case "acc": instruction = Instruction.ACC; break;
                        case "jmp": instruction = Instruction.JMP; break;
                        default:
                            instruction = Instruction.NOP;
                    }

                    return new Pair<Instruction, Integer>(instruction, Integer.parseInt(instructionTokens[1]));
                })
                .collect(Collectors.toList());

        this.instructionOccurences = new ArrayList<Integer>(Collections.nCopies(instructions.size(), 0));
    }

    public boolean step() {
        if (instructionPointer > instructions.size() - 1) {
            return true;
        }

        this.instructionOccurences.set(instructionPointer, this.instructionOccurences.get(instructionPointer)+1);
        final Instruction instruction = this.instructions.get(this.instructionPointer).getFirst();
        final Integer arg = this.instructions.get(this.instructionPointer).getSecond();
        final Pair<Integer, Integer> result = instruction.handle(arg, accumulator, instructionPointer);

        this.accumulator = result.getFirst();
        this.instructionPointer = result.getSecond();
        this.instructionPointer++;

        return false;
    }

    public void stepBack() {
        this.instructionPointer--;
        this.instructionOccurences.set(instructionPointer, this.instructionOccurences.get(instructionPointer)-1);
        final Instruction instruction = this.instructions.get(this.instructionPointer).getFirst();
        final Integer arg = -(this.instructions.get(this.instructionPointer).getSecond());
        final Pair<Integer, Integer> result = instruction.handle(arg, accumulator, instructionPointer);

        accumulator = result.getFirst();
        instructionPointer = result.getSecond();
        this.instructionPointer++;
    }
}
