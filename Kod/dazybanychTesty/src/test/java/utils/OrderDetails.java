package utils;

public class OrderDetails {

    private int idMagazynu;
    private int idProduktu;
    private int ilosc;

    public OrderDetails(int idMagazynu, int idProduktu, int ilosc) {
        this.idMagazynu = idMagazynu;
        this.idProduktu = idProduktu;
        this.ilosc = ilosc;
    }

    public int getIdMagazynu() {
        return idMagazynu;
    }

    public void setIdMagazynu(int idMagazynu) {
        this.idMagazynu = idMagazynu;
    }

    public int getIdProduktu() {
        return idProduktu;
    }

    public void setIdProduktu(int idProduktu) {
        this.idProduktu = idProduktu;
    }

    public int getIlosc() {
        return ilosc;
    }

    public void setIlosc(int ilosc) {
        this.ilosc = ilosc;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        OrderDetails that = (OrderDetails) o;

        if (idMagazynu != that.idMagazynu) return false;
        if (idProduktu != that.idProduktu) return false;
        return ilosc == that.ilosc;

    }

    @Override
    public int hashCode() {
        int result = idMagazynu;
        result = 31 * result + idProduktu;
        result = 31 * result + ilosc;
        return result;
    }
}
