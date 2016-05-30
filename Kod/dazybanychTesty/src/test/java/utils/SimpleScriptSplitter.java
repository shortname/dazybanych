package utils;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class SimpleScriptSplitter {

    public static List<String> splitQueriesFromFile(Path path){
        List<String> queries = new ArrayList<>();
        try(Stream<String> lines = Files.lines(path)){
            Pattern not_empty = Pattern.compile(".*[^\\s]+");
            List<String> content = lines.filter(line -> !line.startsWith("--") && !line.startsWith("#") && not_empty.matcher(line).matches()).collect(Collectors.toList());
            String delimiter = ";";
            String query = "";
            Pattern pattern = Pattern.compile("DELIMITER (.*)");
            for (String line : content){
                Matcher delimiterMatcher = pattern.matcher(line);
                if(delimiterMatcher.matches()) {
                    delimiter = delimiterMatcher.group(1);
                    //queries.add(line);
                }else{
                    if(line.endsWith(delimiter)){
                        queries.add(query + line.replaceAll(delimiter, ""));
                        query = "";
                    }else{
                        query += line + "\n";
                    }
                }
            }
        }catch (IOException exc){
            exc.printStackTrace();
            System.exit(-1);
        }
        return queries;
    }

}
