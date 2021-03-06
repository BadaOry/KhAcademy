package com.kh.array.practice;

import java.util.Arrays;
import java.util.Collections;

public class C_ArraySort {
	public void method1() {
		int[] arr = {2, 5, 7, 1, 3};
		
		for(int value : arr) {
			System.out.print(value + " ");
		}
		
		// 오름차순으로 정렬
		Arrays.sort(arr);
		System.out.println();
		
		for(int value : arr) {
			System.out.print(value + " ");
		}
		
		// 내림차순으로 정렬
		// 1. for 문을 사용해서 원본 배열(오름차순으로 정렬)의 값을 반대로, 새로운 배열에 대입
		// 2. 아래와 같이 작성하는 방법이 있음 (추후에 다시 설명 예정)
		Integer[] integerArray = {2, 5, 7, 1, 3};
		Arrays.sort(integerArray, Collections.reverseOrder());
		
		System.out.println();
		System.out.println(Arrays.toString(integerArray));
	}
	
	public void method2() {
		String[] strArray = {"apple", "orange", "banana", "메론", "레몬"};
		
		// 오름차순으로 정렬
		Arrays.sort(strArray);
		System.out.println(Arrays.toString(strArray));
		
		// 내림차순으로 정렬
		Arrays.sort(strArray, Collections.reverseOrder());
		System.out.println(Arrays.toString(strArray));
	}
	
	/* 조별 과제 )
	 * 정렬 알고리즘 정리
	 * 
	 * 1. 개별로 아래의 정렬 알고리즘을 하나씩 선택해서 정리
	 *    - 삽입 정렬, 버블 정렬, 선택 정렬, 퀵 정렬, 머지 정렬 ...
	 * 
	 * 2. 시간 복잡도, 공간 복잡도는 각각 정리
	 * 
	 * 3. 정리 후 조원들끼리 공유 및 코드 리뷰 진행
	 * 
	 * 4. 이번 주 주말까지 프로젝트 하나 만들어서 내용 정리후 메일 송부
	 */
}
