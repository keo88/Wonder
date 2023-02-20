package kugods.wonder.app.walk.entity;

import javax.persistence.*;

@Table(name = "Tag")
@Entity
public class Tag {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "tag_id")
    private Long tagId;

    @Column(length = 45, nullable = false)
    private String name;

    @ManyToOne
    @JoinColumn(name = "walk_id")
    private Walk walk;
}
