import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class ComputerInterface {
    public static void main(String[] args) {
        final String fileName = "../input.txt";
        final Computer computer;

        try (Stream<String> stream = Files.lines(Paths.get(fileName))) {
            computer = new Computer(stream.collect(Collectors.toList()));
        } catch (IOException e) {
            e.printStackTrace();
            return;
        }

        while (!computer.getInstructionOccurences().contains(2)) {
            computer.step();
        }

        computer.stepBack();
        System.out.println(computer.getAccumulator());
    }
}
