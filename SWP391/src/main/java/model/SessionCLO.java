package model;

public class SessionCLO {
    private int sessionCloId;
    private int sessionId;
    private int cloId;

    public SessionCLO() {
    }

    public SessionCLO(int sessionCloId, int sessionId, int cloId) {
        this.sessionCloId = sessionCloId;
        this.sessionId = sessionId;
        this.cloId = cloId;
    }

    public int getSessionCloId() {
        return sessionCloId;
    }

    public void setSessionCloId(int sessionCloId) {
        this.sessionCloId = sessionCloId;
    }

    public int getSessionId() {
        return sessionId;
    }

    public void setSessionId(int sessionId) {
        this.sessionId = sessionId;
    }

    public int getCloId() {
        return cloId;
    }

    public void setCloId(int cloId) {
        this.cloId = cloId;
    }
}
