package app.shareds.utils;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.File;
import java.io.IOException;
import java.util.List;

public class Helper {
    public static List<String> ReadFile(String path) {
        try {
            ObjectMapper mapper = new ObjectMapper();
            return mapper.readValue(
                    new File(path),
                    new TypeReference<List<String>>() {
                    });
        } catch (IOException e) {
            throw new RuntimeException("Cannot read feature JSON: " + path, e);
        }
    }
}
