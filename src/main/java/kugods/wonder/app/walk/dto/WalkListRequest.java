package kugods.wonder.app.walk.dto;

import lombok.*;

import java.math.BigDecimal;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class WalkListRequest {
    private BigDecimal latitude;

    private BigDecimal longitude;

    private Double range;
}
