#hdkjshf
#kid age/stim race
ggplot(cp_456s, aes(x = factor(age), y = rating)) + 
  facet_wrap(~ stim_race)+
  geom_bar(stat = "summary", fun = "mean")+
  stat_summary(fun.data= "mean_se",
               geom="errorbar",
               width = .2)

ggplot(cp_456s, aes(x= factor(age), y= rating)) +
  facet_wrap(~stim_age) +
  geom_bar(stat = "summary", fun = "mean")+
  stat_summary(fun.data= "mean_se",
               geom="errorbar",
               width = .2)

ggplot(cp_456s, aes(x= factor(age), y= rating)) +
  facet_wrap(~stim_sex) +
  geom_bar(stat = "summary", fun = "mean")+
  stat_summary(fun.data= "mean_se",
               geom="errorbar",
               width = .2)

## injury sum, then geom_col w error bars

cinjurysum <- cp %>%
  group_by(injury) %>%
  summarise(
    counts = n(),
    means = mean(rating, digits = 5),
    sds = sd(rating)) %>%
  mutate(ses = sds/sqrt(counts)) %>%
  mutate(cis = 1.96*ses) 


cinjplot <- cinjurysum %>%
  mutate(injury = fct_relevel(cinjurysum$injury, "paper.cut", "splinter",  "bruised.leg", 
                              "burned.tongue","stomach.ache" ,"bee.sting","skinned.knees",  
                              "broken.arm")) %>% #manually ordered by ascending mean; 
  #can just do ggplot(aes(x=reorder(injury, means), y=means)) but not in rainbow order
  ggplot(aes(x=injury, y=means)) +
  geom_col(aes(fill= factor(injury))) +
  geom_errorbar(aes(ymin = means - cis, ymax = means + cis), width = 0.3) +
  labs(x="Injury", y="Mean Pain Rating (0-7)") +
  ggtitle("Mean Pain Rating by Injury with 95% Confidence Intervals") +
  scale_x_discrete(labels=c("paper.cut" = "paper cut", 
                            "splinter" = "splinter",
                            "bruised.leg" = "bruised leg",
                            "burned.tongue" = "burned tongue",
                            "stomach.ache" = "stomach ache",
                            "bee.sting" = "bee sting",
                            "skinned.knee" = "skinned knee",
                            "broken.arm" = "broken arm")) +
  theme_bw() + 
  theme(text = element_text(size = 13, face="bold"))

print(cinjplot)




## dot plot with CIs   
cagesum <- cp %>%
  group_by(age) %>%
  summarise(
    counts = n(),
    means = mean(rating),
    sds = sd(rating)) %>%
  mutate(ses = sds/sqrt(counts)) %>%
  mutate(cis = 1.96*ses)

cagemeans <- ggplot(cagesum, aes(x=age, y=means)) +
  geom_point(size=1) +
  geom_hline(yintercept = 3.5, color="red") +
  ylim(3,4.5) +
  geom_errorbar(aes(ymin = means - cis, ymax = means + cis), width = 0.6) +
  labs(x="Age", y= "Mean Pain Rating (0-7)") +
  ggtitle("Mean Pain Rating for Adult vs Child Vignettes") +
  theme_bw() 

print(cagemeans)

csexsum <- cp %>%
  group_by(sex) %>%
  summarise(
    counts = n(),
    means = mean(rating),
    sds = sd(rating)) %>%
  mutate(ses = sds/sqrt(counts)) %>%
  mutate(cis = 1.96*ses)

csexmeans <- ggplot(csexsum, aes(x=sex, y=means)) +
  geom_point(size=1) +
  geom_hline(yintercept = 3.5, color="red") +
  ylim(3,4.5) +
  geom_errorbar(aes(ymin = means - cis, ymax = means + cis), width = 0.6) +
  labs(x="Sex", y= "Mean Pain Rating (0-7)") +
  ggtitle("Mean Pain Rating for Female vs Male Vignettes") +
  theme_bw() 

print(csexmeans)

cracesum <- cp %>%
  group_by(race) %>%
  summarise(
    counts = n(),
    means = mean(rating),
    sds = sd(rating)) %>%
  mutate(ses = sds/sqrt(counts)) %>%
  mutate(cis = 1.96*ses)

cracemeans <- ggplot(cracesum, aes(x=race, y=means)) +
  geom_point(size=1) +
  geom_hline(yintercept = 3.5, color="red") +
  ylim(3,4.5) +
  geom_errorbar(aes(ymin = means - cis, ymax = means + cis), width = 0.6) +
  labs(x="Race", y= "Mean Pain Rating (0-7)") +
  ggtitle("Mean Pain Rating for Black vs White Vignettes") +
  theme_bw() 

print(cracemeans)


#controlling for injury (basically same as lm1)
lm2 <- lmer(rating ~ sex + race + age + injury + (1|cp_number), data=cp)
summary(lm2)
Anova(lm2)

lmeff <- lmer(rating ~ race + sex + age + injury + (1|cp_number), data=cp)
summary(lmeff)
Anova(lmeff)


