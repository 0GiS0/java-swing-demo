public class TalkProposal {
    private int id;
    private String speakerName;
    private String talkTitle;
    private String abstractText;
    private String duration;
    private String category;
    private String experienceLevel;
    private String email;
    private String status;

    public TalkProposal(int id, String speakerName, String talkTitle, String abstractText,
                        String duration, String category, String experienceLevel, String email, String status) {
        this.id = id;
        this.speakerName = speakerName;
        this.talkTitle = talkTitle;
        this.abstractText = abstractText;
        this.duration = duration;
        this.category = category;
        this.experienceLevel = experienceLevel;
        this.email = email;
        this.status = status;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getSpeakerName() {
        return speakerName;
    }

    public void setSpeakerName(String speakerName) {
        this.speakerName = speakerName;
    }

    public String getTalkTitle() {
        return talkTitle;
    }

    public void setTalkTitle(String talkTitle) {
        this.talkTitle = talkTitle;
    }

    public String getAbstractText() {
        return abstractText;
    }

    public void setAbstractText(String abstractText) {
        this.abstractText = abstractText;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getExperienceLevel() {
        return experienceLevel;
    }

    public void setExperienceLevel(String experienceLevel) {
        this.experienceLevel = experienceLevel;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "TalkProposal{" +
                "id=" + id +
                ", speakerName='" + speakerName + '\'' +
                ", talkTitle='" + talkTitle + '\'' +
                ", duration='" + duration + '\'' +
                ", category='" + category + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
