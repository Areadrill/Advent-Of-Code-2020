import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public class ComputerInterface {
    public static void main(String[] args) {
        final String fileName = "../input.txt";
        final List<String> instructionSet;

        try (Stream<String> stream = Files.lines(Paths.get(fileName))) {
            instructionSet = stream.collect(Collectors.toList());
        } catch (IOException e) {
            e.printStackTrace();
            return;
        }

        IntStream.range(0, instructionSet.size()).boxed()
                .filter(num -> instructionSet.get(num).matches("(jmp|nop) .*"))
                .forEach(num -> {
                    final List<String> changedInstructionSet = new ArrayList(instructionSet);
                    final String originalInstruction = instructionSet.get(num);
                    final String arg = originalInstruction.split(" ")[1];

                    if (originalInstruction.matches("jmp .+")) {
                        changedInstructionSet.set(num, "nop " + arg);
                    } else {
                        changedInstructionSet.set(num, "jmp " + arg);
                    }

                    final Computer computer = new Computer(changedInstructionSet);
                    boolean reachesEnd = false;

                    while (!computer.getInstructionOccurences().contains(2) && !reachesEnd) {
                        reachesEnd = computer.step();
                    }

                    if(reachesEnd) {
                        System.out.println(computer.getAccumulator());
                        System.exit(0);
                    }
                });
    }
}
