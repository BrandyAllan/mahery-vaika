package tools;

public class MonException extends Exception{

    public MonException(String message) {
        super(message);
    }

    public String toString() {
        return super.getMessage();
    }
}
