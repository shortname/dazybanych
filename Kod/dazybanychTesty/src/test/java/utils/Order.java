package utils;

public class Order {

    private int id;
    private int idKlienta;
    private String status;

    public Order(int id, int idKlienta, String status) {
        this.id = id;
        this.idKlienta = idKlienta;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getIdKlienta() {
        return idKlienta;
    }

    public void setIdKlienta(int idKlienta) {
        this.idKlienta = idKlienta;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Order order = (Order) o;

        if (idKlienta != order.idKlienta) return false;
        return status.equals(order.status);

    }

    @Override
    public int hashCode() {
        int result = idKlienta;
        result = 31 * result + status.hashCode();
        return result;
    }
}
